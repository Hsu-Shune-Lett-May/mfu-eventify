import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/event_model.dart';
import 'firestore_service.dart';
import 'hive_service.dart';

/// Offline-first repository:
/// 1. Always read from Hive first for instant UI.
/// 2. When online, fetch from Firestore, update Hive cache, and return fresh data.
/// 3. Writes go to Firestore when online, and always update Hive.
class EventRepository {
  final FirestoreService _firestoreService;
  final HiveService _hiveService;

  EventRepository({
    required FirestoreService firestoreService,
    required HiveService hiveService,
  })  : _firestoreService = firestoreService,
        _hiveService = hiveService;

  /// Check if device is online
  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Get events from local Hive cache only (no network calls)
  List<EventModel> getLocalEvents() {
    return _hiveService.getEvents();
  }

  /// Cache sample events locally
  Future<void> cacheSampleEvents(List<EventModel> events) async {
    await _hiveService.cacheEvents(events);
  }

  /// Get all events (offline-first)
  Future<List<EventModel>> getEvents() async {
    // 1. Start with cached data
    List<EventModel> events = _hiveService.getEvents();

    // 2. Try to sync with Firestore (with timeout)
    if (await _isOnline()) {
      try {
        final remoteEvents = await _firestoreService
            .getEvents()
            .timeout(const Duration(seconds: 10));

        // Apply local saved status to remote events
        final savedIds = _hiveService.getSavedEventIds();
        for (final event in remoteEvents) {
          event.isSaved = savedIds.contains(event.id);
        }

        // Update cache
        await _hiveService.cacheEvents(remoteEvents);
        events = remoteEvents;
      } catch (_) {
        // If Firestore fails or times out, we already have cached data
      }
    }

    return events;
  }

  /// Get saved events from local cache
  List<EventModel> getSavedEvents() {
    return _hiveService.getSavedEvents();
  }

  /// Toggle save status of an event
  Future<void> toggleSaveEvent(String eventId) async {
    await _hiveService.toggleSaved(eventId);
  }

  /// Check if an event is saved
  bool isEventSaved(String eventId) {
    return _hiveService.isSaved(eventId);
  }

  /// Create a new event (idempotent)
  Future<EventModel?> createEvent(
    EventModel event, {
    required String createdByUserId,
  }) async {
    if (_hiveService.containsEvent(event.id)) {
      return _hiveService.getEventById(event.id);
    }

    await _hiveService.cacheEvent(event);
    await _hiveService.markMyEvent(event.id);

    if (await _isOnline()) {
      try {
        await _firestoreService
            .upsertEvent(
              event,
              createdByUserId: createdByUserId,
            )
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        // Best effort sync failed, event remains cached locally.
      }
    }

    return event;
  }

  Future<void> updateEvent(EventModel event) async {
    await _hiveService.updateEvent(event);

    if (await _isOnline()) {
      try {
        await _firestoreService
            .updateEvent(event)
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        // Keep local update; remote sync is best effort.
      }
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await _hiveService.deleteEvent(eventId);

    if (await _isOnline()) {
      try {
        await _firestoreService
            .deleteEvent(eventId)
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        // Local delete is already applied.
      }
    }
  }

  List<EventModel> getMyEvents() {
    final myEventIds = _hiveService.getMyEventIds();
    return _hiveService
        .getEvents()
        .where((event) => myEventIds.contains(event.id))
        .toList();
  }

  Set<String> getMyEventIds() {
    return _hiveService.getMyEventIds();
  }

  /// Seed Firestore with sample data if empty, then cache
  Future<void> seedAndSync() async {
    if (await _isOnline()) {
      try {
        await _firestoreService.seedIfEmpty().timeout(
          const Duration(seconds: 10),
        );
        final events = await _firestoreService
            .getEvents()
            .timeout(const Duration(seconds: 10));
        await _hiveService.cacheEvents(events);
      } catch (_) {
        // Seeding failed or timed out, will work from cache
      }
    }
  }
}
