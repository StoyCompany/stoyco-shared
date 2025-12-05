import 'package:stoyco_shared/radio/online_members_tracking_service.dart';

/// Service for tracking radio listeners.
///
/// Wrapper of OnlineMembersTrackingService specialized for
/// the 'radios' collection in Firestore.
///
/// Provides methods with semantic names for the radio domain:
/// - startListening: User starts listening
/// - stopListening: User stops listening
/// - updateActivity: Updates last activity
/// - watchListenerCount: Watches counter in real-time
class RadioTrackingService {
  RadioTrackingService({OnlineMembersTrackingService? trackingService})
      : _trackingService = trackingService ?? OnlineMembersTrackingService();

  static const String _collection = 'radios';
  final OnlineMembersTrackingService _trackingService;

  /// Increments the counter when a user starts listening.
  ///
  /// [radioId] Radio document ID in Firestore.
  Future<void> startListening(String radioId) async {
    await _trackingService.incrementOnlineCount(
      collection: _collection,
      documentId: radioId,
    );
  }

  /// Decrements the counter when a user stops listening.
  ///
  /// [radioId] Radio document ID in Firestore.
  Future<void> stopListening(String radioId) async {
    await _trackingService.decrementOnlineCount(
      collection: _collection,
      documentId: radioId,
    );
  }

  /// Updates the last activity without modifying the counter.
  ///
  /// Useful for maintaining a "heartbeat" that the user is still active.
  /// [radioId] Radio document ID in Firestore.
  Future<void> updateActivity(String radioId) async {
    await _trackingService.updateLastActivity(
      collection: _collection,
      documentId: radioId,
    );
  }

  /// Stream of the number of listeners in real-time.
  ///
  /// Emits a new value each time the counter changes in Firestore.
  /// [radioId] Radio document ID in Firestore.
  Stream<int> watchListenerCount(String radioId) => _trackingService.watchOnlineCount(
      collection: _collection,
      documentId: radioId,
    );
}
