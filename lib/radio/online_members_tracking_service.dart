import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic service for tracking online members.
/// Can be used for radios, live events, chat rooms, etc.
///
/// This service manages real-time active user counters in Firestore,
/// incrementing and decrementing according to activity.
class OnlineMembersTrackingService {

  OnlineMembersTrackingService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Increments the online members counter.
  ///
  /// Updates the following fields:
  /// - members_online_count: +1
  /// - app_last_increment: current timestamp
  /// - last_app_activity: current timestamp
  Future<void> incrementOnlineCount({
    required String collection,
    required String documentId,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _firestore.collection(collection).doc(documentId).update({
      'members_online_count': FieldValue.increment(1),
      'app_last_increment': now,
      'last_app_activity': now,
    });
  }

  /// Decrements the online members counter.
  ///
  /// Only decrements if the current counter is greater than 0.
  /// Updates the following fields:
  /// - members_online_count: -1 (if > 0)
  /// - app_last_decrement: current timestamp
  /// - last_app_activity: current timestamp
  Future<void> decrementOnlineCount({
    required String collection,
    required String documentId,
  }) async {
    final now = FieldValue.serverTimestamp();

    final doc = await _firestore.collection(collection).doc(documentId).get();
    final currentCount = doc.data()?['members_online_count'] ?? 0;

    if (currentCount > 0) {
      await _firestore.collection(collection).doc(documentId).update({
        'members_online_count': FieldValue.increment(-1),
        'app_last_decrement': now,
        'last_app_activity': now,
      });
    }
  }

  /// Updates only the last activity without modifying counters.
  ///
  /// Useful for maintaining a user activity "heartbeat"
  /// without incrementing/decrementing the counter.
  Future<void> updateLastActivity({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).update({
      'last_app_activity': FieldValue.serverTimestamp(),
    });
  }

  /// Gets the current number of online members in real-time.
  ///
  /// Returns a Stream that emits the counter every time it changes.
  Stream<int> watchOnlineCount({
    required String collection,
    required String documentId,
  }) => _firestore
        .collection(collection)
        .doc(documentId)
        .snapshots()
        .map((doc) => doc.data()?['members_online_count'] ?? 0);
}
