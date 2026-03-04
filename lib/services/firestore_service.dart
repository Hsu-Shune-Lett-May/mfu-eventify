import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _eventsCollection = 'events';

  /// Fetch all events from Firestore
  Future<List<EventModel>> getEvents() async {
    final snapshot = await _firestore.collection(_eventsCollection).get();
    return snapshot.docs
        .map((doc) => EventModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Create or update an event in Firestore using a deterministic ID.
  /// This makes creates idempotent (safe against double tap submissions).
  Future<EventModel> upsertEvent(
    EventModel event, {
    required String createdByUserId,
  }) async {
    await _firestore.collection(_eventsCollection).doc(event.id).set(
      {
        ...event.toMap(),
        'createdByUserId': createdByUserId,
      },
      SetOptions(merge: true),
    );
    return event;
  }

  /// Update an existing event in Firestore
  Future<void> updateEvent(EventModel event) async {
    await _firestore
        .collection(_eventsCollection)
        .doc(event.id)
        .update(event.toMap());
  }

  /// Delete an event from Firestore
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection(_eventsCollection).doc(eventId).delete();
  }

  /// Seed Firestore with sample data if the collection is empty
  Future<void> seedIfEmpty() async {
    final snapshot = await _firestore.collection(_eventsCollection).get();
    if (snapshot.docs.isEmpty) {
      final batch = _firestore.batch();
      for (final event in EventModel.getSampleEvents()) {
        final docRef = _firestore.collection(_eventsCollection).doc(event.id);
        batch.set(docRef, {
          ...event.toMap(),
          'createdByUserId': 'system',
        });
      }
      await batch.commit();
    }
  }
}
