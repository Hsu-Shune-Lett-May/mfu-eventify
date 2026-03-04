import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/event_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  String? _lastError;

  String? get lastError => _lastError;

  static const String _channelId = 'event_reminders';
  static const String _channelName = 'Event Reminders';
  static const String _channelDescription =
      'Notifications for scheduled event reminders';

  Future<void> initialize() async {
    if (kIsWeb) {
      _lastError = 'Web platform does not support local notifications.';
      debugPrint('NotificationService: $_lastError');
      return;
    }

    try {
      tz.initializeTimeZones();

      final localTimeZone = await FlutterTimezone.getLocalTimezone();
      try {
        tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));
      } catch (e, st) {
        _lastError =
            'Failed to set timezone ${localTimeZone.identifier}. Falling back to UTC. Error: $e';
        debugPrint('NotificationService: $_lastError');
        debugPrint('$st');
        tz.setLocalLocation(tz.UTC);
      }

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      await _requestPermissions();
      await _createNotificationChannel();
      _isInitialized = true;
      _lastError = null;
      debugPrint('NotificationService: initialization complete.');
    } catch (e, st) {
      _isInitialized = false;
      _lastError = 'NotificationService initialization failed: $e';
      debugPrint(_lastError);
      debugPrint('$st');
    }
  }

  Future<void> _requestPermissions() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  Future<bool> scheduleEventReminder({
    required EventModel event,
    required DateTime scheduledAt,
    required String reminderLabel,
  }) async {
    if (!_isInitialized) {
      _lastError = 'NotificationService not initialized.';
      debugPrint('scheduleEventReminder failed: $_lastError');
      return false;
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      _lastError =
          'Scheduled time is in the past. Event: ${event.id}, scheduledAt: $scheduledAt';
      debugPrint('scheduleEventReminder failed: $_lastError');
      return false;
    }

    final notificationId = _notificationIdFromEventId(event.id);
    final scheduledDate = tz.TZDateTime.from(scheduledAt, tz.local);

    try {
      debugPrint('Scheduling reminder: eventId=${event.id}, notificationId=$notificationId, tz=${tz.local.name}, scheduledAt=$scheduledDate');

      await _plugin.zonedSchedule(
        id: notificationId,
        title: 'Event Reminder',
        body: '${event.title} starts soon ($reminderLabel before)',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: event.id,
      );

      _lastError = null;
      debugPrint('Reminder scheduled successfully for event ${event.id}.');
      return true;
    } catch (e, st) {
      _lastError = 'scheduleEventReminder failed for event ${event.id}: $e';
      debugPrint(_lastError);
      debugPrint('$st');
      return false;
    }
  }

  Future<void> cancelReminder(String eventId) async {
    if (!_isInitialized) {
      return;
    }

    await _plugin.cancel(id: _notificationIdFromEventId(eventId));
  }

  int _notificationIdFromEventId(String eventId) {
    var hash = 0;
    for (var i = 0; i < eventId.length; i++) {
      hash = ((hash * 31) + eventId.codeUnitAt(i)) & 0x7fffffff;
    }
    return hash;
  }
}
