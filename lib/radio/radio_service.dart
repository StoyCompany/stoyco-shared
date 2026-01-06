import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Centralized service for radio functionality.
///
/// Handles fetching radios from Firestore.
class RadioService {
  RadioService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
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

  /// Gets the playback count of a radio.
  ///
  /// [radioId] The radio ID.
  /// Returns the total number of playbacks.
  Future<int> getPlaybackCount(String radioId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(radioId).get();
      return doc.data()?['playback_count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Watches the real-time playback count for a radio.
  ///
  /// [radioId] The radio document ID.
  /// Returns a [Stream] that emits the current playback count.
  Stream<int> watchPlaybackCount(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        if (data == null) return 0;

        return data['playback_count'] ?? 0;
      });

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
