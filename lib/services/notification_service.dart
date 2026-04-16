import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: _channelDescription,
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
  );

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    if (kIsWeb) {
      _lastError = 'Web platform does not support local notifications.';
      debugPrint('NotificationService: $_lastError');
      return false;
    }

    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      final bool? initialized = await _plugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(_channel);
      }

      _isInitialized = initialized ?? false;
      _lastError = null;
      debugPrint('NotificationService: initialization complete.');
      return _isInitialized;
    } catch (e, st) {
      _isInitialized = false;
      _lastError = 'NotificationService initialization failed: $e';
      debugPrint(_lastError);
      debugPrint('$st');
      return false;
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        final bool? granted =
            await androidPlugin?.requestNotificationsPermission();
        await androidPlugin?.requestExactAlarmsPermission();
        return granted ?? false;
      } else if (Platform.isIOS) {
        final bool? granted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return granted ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  Future<bool> scheduleEventReminder({
    required EventModel event,
    required DateTime scheduledAt,
    required String reminderLabel,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        _lastError = 'NotificationService not initialized.';
        debugPrint('scheduleEventReminder failed: $_lastError');
        return false;
      }
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      _lastError =
          'Scheduled time is in the past. Event: ${event.id}, scheduledAt: $scheduledAt';
      debugPrint('scheduleEventReminder failed: $_lastError');
      return false;
    }

    final notificationId = _notificationIdFromEventId(event.id);
    final bangkok = tz.getLocation('Asia/Bangkok');
    final scheduledDate = tz.TZDateTime.from(scheduledAt, bangkok);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      debugPrint(
          'Scheduling reminder: eventId=${event.id}, notificationId=$notificationId, scheduledAt=$scheduledDate');

      await _plugin.zonedSchedule(
        notificationId,
        'Event Reminder',
        '${event.title} starts soon ($reminderLabel before)',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
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
    if (!_isInitialized) return;
    await _plugin.cancel(_notificationIdFromEventId(eventId));
  }

  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  int _notificationIdFromEventId(String eventId) {
    var hash = 0;
    for (var i = 0; i < eventId.length; i++) {
      hash = ((hash * 31) + eventId.codeUnitAt(i)) & 0x7fffffff;
    }
    return hash;
  }
}