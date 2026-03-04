import 'package:hive/hive.dart';
import '../models/event_model.dart';

class HiveService {
  static const String _eventsBoxName = 'events';
  static const String _savedEventsBoxName = 'saved_events';
  static const String _myEventsBoxName = 'my_events';

  /// Get the events box
  Box<EventModel> get _eventsBox => Hive.box<EventModel>(_eventsBoxName);

  /// Get the saved event IDs box
  Box<String> get _savedBox => Hive.box<String>(_savedEventsBoxName);

  /// Get the current user's created event IDs box
  Box<String> get _myEventsBox => Hive.box<String>(_myEventsBoxName);

  /// Open all required Hive boxes
  static Future<void> init() async {
    await Hive.openBox<EventModel>(_eventsBoxName);
    await Hive.openBox<String>(_savedEventsBoxName);
    await Hive.openBox<String>(_myEventsBoxName);
  }

  /// Get all cached events
  List<EventModel> getEvents() {
    final events = _eventsBox.values.toList();
    // Apply saved status from the saved box
    for (final event in events) {
      event.isSaved = _savedBox.containsKey(event.id);
    }
    return events;
  }

  /// Cache a list of events (replaces all existing)
  Future<void> cacheEvents(List<EventModel> events) async {
    await _eventsBox.clear();
    final map = <String, EventModel>{};
    for (final event in events) {
      map[event.id] = event;
    }
    await _eventsBox.putAll(map);
  }

  /// Add a single event to the cache
  Future<void> cacheEvent(EventModel event) async {
    await _eventsBox.put(event.id, event);
  }

  EventModel? getEventById(String eventId) {
    return _eventsBox.get(eventId);
  }

  bool containsEvent(String eventId) {
    return _eventsBox.containsKey(eventId);
  }

  Future<void> updateEvent(EventModel event) async {
    await _eventsBox.put(event.id, event);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsBox.delete(eventId);
    await _savedBox.delete(eventId);
    await _myEventsBox.delete(eventId);
  }

  /// Toggle saved status for an event
  Future<void> toggleSaved(String eventId) async {
    if (_savedBox.containsKey(eventId)) {
      await _savedBox.delete(eventId);
    } else {
      await _savedBox.put(eventId, eventId);
    }
  }

  /// Check if an event is saved
  bool isSaved(String eventId) {
    return _savedBox.containsKey(eventId);
  }

  /// Get all saved event IDs
  Set<String> getSavedEventIds() {
    return _savedBox.values.toSet();
  }

  /// Get saved events
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

  Set<String> getMyEventIds() {
    return _myEventsBox.values.toSet();
  }

  Future<void> unmarkMyEvent(String eventId) async {
    await _myEventsBox.delete(eventId);
  }
}
