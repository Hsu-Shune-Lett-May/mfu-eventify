import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../services/event_repository.dart';
import '../services/notification_service.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _repository;
  final NotificationService _notificationService;

  static const String currentUserId = 'mfu_user_1';

  List<EventModel> _events = [];
  bool _isLoading = false;
  bool _isCreatingEvent = false;
  final Set<String> _deletingEventIds = <String>{};
  Set<String> _myEventIds = <String>{};
  String? _error;

  EventProvider({
    required EventRepository repository,
    required NotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  List<EventModel> get events => _events;
  List<EventModel> get savedEvents =>
      _events.where((e) => e.isSaved).toList();
  List<EventModel> get myEvents =>
      _events.where((event) => _myEventIds.contains(event.id)).toList();
  bool get isLoading => _isLoading;
  bool get isCreatingEvent => _isCreatingEvent;
  String? get error => _error;

  bool isDeletingEvent(String eventId) => _deletingEventIds.contains(eventId);

  EventModel? getEventById(String eventId) {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) {
      return null;
    }
    return _events[index];
  }

  /// Initialize: load from cache first (instant), then sync with Firestore
  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // 1. Load from Hive cache instantly (no network)
    _events = _repository.getLocalEvents();
    _myEventIds = _repository.getMyEventIds();

    // If cache is empty, use sample events as fallback
    if (_events.isEmpty) {
      _events = EventModel.getSampleEvents();
      // Cache them locally for next time
      await _repository.cacheSampleEvents(_events);
    }

    _isLoading = false;
    notifyListeners();

    // 2. Sync with Firestore in background (non-blocking)
    try {
      await _repository.seedAndSync().timeout(
        const Duration(seconds: 10),
      );
      final refreshed = _repository.getLocalEvents();
      if (refreshed.isNotEmpty) {
        _events = refreshed;
        _myEventIds = _repository.getMyEventIds();
        notifyListeners();
      }
    } catch (_) {
      // Firestore sync failed or timed out — we already have data showing
    }
  }

  /// Refresh events from Firestore / cache
  Future<void> refreshEvents() async {
    _error = null;

    try {
      _events = await _repository.getEvents();
      _myEventIds = _repository.getMyEventIds();
    } catch (e) {
      _error = e.toString();
      debugPrint('refreshEvents failed: $e');
    }

    notifyListeners();
  }

  /// Toggle save status
  Future<void> toggleSaveEvent(String eventId) async {
    await _repository.toggleSaveEvent(eventId);

    // Update local list
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _events[index].isSaved = !_events[index].isSaved;
    }
    notifyListeners();
  }

  /// Create a new event
  Future<bool> createEvent(EventModel event) async {
    if (_isCreatingEvent) {
      return false;
    }

    _isCreatingEvent = true;
    notifyListeners();

    try {
      final created = await _repository.createEvent(
        event,
        createdByUserId: currentUserId,
      );

      if (created != null) {
        final existingIndex = _events.indexWhere((e) => e.id == created.id);
        if (existingIndex == -1) {
          _events.insert(0, created);
        } else {
          _events[existingIndex] = created;
        }
        _myEventIds.add(created.id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isCreatingEvent = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    final existingIndex = _events.indexWhere((e) => e.id == eventId);
    if (existingIndex == -1) {
      return false;
    }

    final deletedEvent = _events[existingIndex];
    _deletingEventIds.add(eventId);
    _events.removeAt(existingIndex);
    _myEventIds.remove(eventId);
    notifyListeners();

    try {
      await _notificationService.cancelReminder(eventId);
      await _repository.deleteEvent(eventId);
      return true;
    } catch (e) {
      _events.insert(existingIndex, deletedEvent);
      _myEventIds.add(eventId);
      _error = e.toString();
      debugPrint('deleteEvent failed for $eventId: $e');
      notifyListeners();
      return false;
    } finally {
      _deletingEventIds.remove(eventId);
      notifyListeners();
    }
  }

  Future<bool> setReminderForEvent({
    required String eventId,
    required Duration remindBefore,
    required String reminderLabel,
  }) async {
    final eventIndex = _events.indexWhere((event) => event.id == eventId);
    if (eventIndex == -1) {
      return false;
    }

    final event = _events[eventIndex];
    final startDateTime = _parseEventStartDateTime(event);
    if (startDateTime == null) {
      _error = 'Invalid event date/time format';
      debugPrint('setReminderForEvent failed: unable to parse date/time for event ${event.id} (${event.date} ${event.time})');
      notifyListeners();
      return false;
    }

    final scheduledAt = startDateTime.subtract(remindBefore);
    if (scheduledAt.isBefore(DateTime.now())) {
      _error = 'Reminder time has already passed';
      debugPrint('setReminderForEvent failed: reminder time already passed for event ${event.id}');
      notifyListeners();
      return false;
    }

    final scheduled = await _notificationService.scheduleEventReminder(
      event: event,
      scheduledAt: scheduledAt,
      reminderLabel: reminderLabel,
    );

    // On web, notifications aren't supported but we still mark the reminder
    if (!scheduled && !kIsWeb) {
      _error = _notificationService.lastError ??
          'Unable to schedule reminder. Check logs for details.';
      debugPrint('setReminderForEvent failed: $_error');
      notifyListeners();
      return false;
    }

    final updatedEvent = event.copyWith(isReminderSet: true);
    _events[eventIndex] = updatedEvent;
    await _repository.updateEvent(updatedEvent);
    notifyListeners();
    return true;
  }

  DateTime? _parseEventStartDateTime(EventModel event) {
    final startTime = event.time.split('-').first.trim();
    final raw = '${event.date.trim()} $startTime';

    final patterns = <DateFormat>[
      DateFormat('MMM d, y h:mm a'),
      DateFormat('MMM d, y H:mm'),
      DateFormat('d/M/y h:mm a'),
      DateFormat('d/M/y H:mm'),
      DateFormat('y-M-d h:mm a'),
      DateFormat('y-M-d H:mm'),
    ];

    for (final formatter in patterns) {
      try {
        return formatter.parseStrict(raw);
      } catch (_) {
        // Try next pattern.
      }
    }

    try {
      final datePart = DateFormat('MMM d, y').parseStrict(event.date.trim());
      final parsedTime = DateFormat.jm().parseStrict(startTime);
      return DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (_) {
      // ignore
    }

    try {
      final datePart = DateFormat('d/M/y').parseStrict(event.date.trim());
      final parsedTime = DateFormat.Hm().parseStrict(startTime);
      return DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (_) {
      // ignore
    }

    return null;
  }
}
