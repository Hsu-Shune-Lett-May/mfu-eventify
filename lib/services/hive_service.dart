import 'package:hive/hive.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _eventsBoxName = 'events';
  static const String _savedEventsBoxName = 'saved_events';
  static const String _myEventsBoxName = 'my_events';
  static const String _userBoxName = 'user';         // ← new

  Box<EventModel> get _eventsBox => Hive.box<EventModel>(_eventsBoxName);
  Box<String> get _savedBox => Hive.box<String>(_savedEventsBoxName);
  Box<String> get _myEventsBox => Hive.box<String>(_myEventsBoxName);
  Box<UserModel> get _userBox => Hive.box<UserModel>(_userBoxName);  // ← new

  static Future<void> init() async {
    await Hive.openBox<EventModel>(_eventsBoxName);
    await Hive.openBox<String>(_savedEventsBoxName);
    await Hive.openBox<String>(_myEventsBoxName);
    await Hive.openBox<UserModel>(_userBoxName);      // ← new
  }

  // ─── User Cache ──────────────────────────────────────────────

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  UserModel? getUser() {
    return _userBox.get('current_user');
  }

  Future<void> clearUser() async {
    await _userBox.delete('current_user');
  }

  // ─── Events (unchanged) ──────────────────────────────────────

  List<EventModel> getEvents() {
    final events = _eventsBox.values.toList();
    for (final event in events) {
      event.isSaved = _savedBox.containsKey(event.id);
    }
    return events;
  }

  Future<void> cacheEvents(List<EventModel> events) async {
    await _eventsBox.clear();
    final map = <String, EventModel>{};
    for (final event in events) {
      map[event.id] = event;
    }
    await _eventsBox.putAll(map);
  }

  Future<void> cacheEvent(EventModel event) async {
    await _eventsBox.put(event.id, event);
  }

  EventModel? getEventById(String eventId) => _eventsBox.get(eventId);
  bool containsEvent(String eventId) => _eventsBox.containsKey(eventId);

  Future<void> updateEvent(EventModel event) async {
    await _eventsBox.put(event.id, event);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsBox.delete(eventId);
    await _savedBox.delete(eventId);
    await _myEventsBox.delete(eventId);
  }

  Future<void> toggleSaved(String eventId) async {
    if (_savedBox.containsKey(eventId)) {
      await _savedBox.delete(eventId);
    } else {
      await _savedBox.put(eventId, eventId);
    }
  }

  bool isSaved(String eventId) => _savedBox.containsKey(eventId);
  Set<String> getSavedEventIds() => _savedBox.values.toSet();

  List<EventModel> getSavedEvents() {
    final savedIds = getSavedEventIds();
    return _eventsBox.values
        .where((e) => savedIds.contains(e.id))
          .map((e) => e.copyWith(isSaved: true))
          .toList();
    }

    Future<void> markMyEvent(String eventId) async {
      await _myEventsBox.put(eventId, eventId);
    }

    Set<String> getMyEventIds() => _myEventsBox.values.toSet();

    Future<void> unmarkMyEvent(String eventId) async {
      await _myEventsBox.delete(eventId);
    }
  }