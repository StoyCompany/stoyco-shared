import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Centralized service for radio functionality.
///
/// Handles fetching radios from Firestore and real-time listener tracking.
///
/// Example:
/// ```dart
/// final service = RadioService();
/// final radios = await service.getActiveRadios();
/// await service.startListening('radioId');
/// ```
class RadioService {
  RadioService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'radios';

  /// Gets all active radios ordered by creation date.
  ///
  /// Returns a list of [RadioModel] with status 'active'.
  Future<List<RadioModel>> getActiveRadios() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList();
  }

  /// Gets radios filtered by partner/community owner.
  ///
  /// [partnerId] The community owner ID to filter by.
  /// Returns a list of active [RadioModel] for the specified partner.
  Future<List<RadioModel>> getRadiosByPartner(String partnerId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('communityOwnerId', isEqualTo: partnerId)
        .where('status', isEqualTo: 'active')
        .get();
    return snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList();
  }

  /// Gets a single radio by its ID.
  ///
  /// [radioId] The Firestore document ID of the radio.
  /// Returns the [RadioModel] if found, or `null` if not exists.
  Future<RadioModel?> getRadioById(String radioId) async {
    final doc = await _firestore.collection(_collection).doc(radioId).get();
    return doc.exists ? RadioModel.fromFirestore(doc) : null;
  }

  /// Increments the listener count when a user starts listening.
  ///
  /// [radioId] The radio document ID.
  /// Updates `members_online_count`, `app_last_increment`, and `last_app_activity`.
  Future<void> startListening(String radioId) async {
    try {
      final now = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(radioId).update({
        'members_online_count': FieldValue.increment(1),
        'app_last_increment': now,
        'last_app_activity': now,
      });
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error incrementing listener count',
        error: e,
      );
    }
  }

  /// Decrements the listener count when a user stops listening.
  ///
  /// [radioId] The radio document ID.
  /// Only decrements if the current count is greater than 0.
  Future<void> stopListening(String radioId) async {
    try {
      final now = FieldValue.serverTimestamp();
      final doc = await _firestore.collection(_collection).doc(radioId).get();
      final currentCount = doc.data()?['members_online_count'] ?? 0;

      if (currentCount > 0) {
        await _firestore.collection(_collection).doc(radioId).update({
          'members_online_count': FieldValue.increment(-1),
          'app_last_decrement': now,
          'last_app_activity': now,
        });
      }
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error decrementing listener count',
        error: e,
      );
    }
  }

  /// Watches the real-time listener count for a radio.
  ///
  /// [radioId] The radio document ID.
  /// Returns a [Stream] that emits the current listener count.
  Stream<int> watchListenerCount(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) => doc.data()?['members_online_count'] ?? 0);

  /// Increments the total donated StoyCoins for a radio.
  ///
  /// [radioId] The radio document ID.
  /// [amount] The number of StoyCoins to increment.
  /// Updates `totalDonatedStoyCoins` field using atomic increment.
  ///
  /// Example:
  /// ```dart
  /// await radioService.incrementDonatedStoyCoins('radio123', 1);
  /// ```
  Future<void> incrementDonatedStoyCoins(String radioId, int amount) async {
    try {
      await _firestore.collection(_collection).doc(radioId).update({
        'totalDonatedStoyCoins': FieldValue.increment(amount),
      });
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error incrementing donated StoyCoins',
        error: e,
      );
      rethrow;
    }
  }
}
