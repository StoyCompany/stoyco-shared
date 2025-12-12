import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:uuid/uuid.dart';

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
  RadioService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collection = 'radios';

  /// Anonymous session ID for non-authenticated users.
  String? _anonymousSessionId;

  /// Gets the current listener ID.
  ///
  /// Returns the authenticated user's UID if logged in,
  /// otherwise generates and returns a temporary anonymous session ID.
  String _getListenerId() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) return userId;

    _anonymousSessionId ??= 'anon_${const Uuid().v4()}';
    return _anonymousSessionId!;
  }

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

  /// Adds the current user or anonymous session to the active listeners array.
  ///
  /// [radioId] The radio document ID.
  /// Updates `active_listeners` array with the listener's ID.
  /// For authenticated users, uses their UID.
  /// For anonymous users, generates a temporary session ID (anon_xxxx).
  /// Only adds the listener if not already in the array (using arrayUnion).
  /// Also updates `app_last_increment` and `last_app_activity` timestamps.
  /// Uses set with merge:true to create the field if it doesn't exist.
  Future<void> startListening(String radioId) async {
    try {
      final listenerId = _getListenerId();

      final now = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(radioId).set({
        'active_listeners': FieldValue.arrayUnion([listenerId]),
        'app_last_increment': now,
        'last_app_activity': now,
      }, SetOptions(merge: true));
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error adding user to active listeners',
        error: e,
      );
    }
  }

  /// Removes the current user or anonymous session from the active listeners array.
  ///
  /// [radioId] The radio document ID.
  /// Updates `active_listeners` array by removing the listener's ID.
  /// Uses arrayRemove to safely remove only if the listener exists in the array.
  /// Also updates `app_last_decrement` and `last_app_activity` timestamps.
  /// Uses set with merge:true to handle cases where the field might not exist.
  Future<void> stopListening(String radioId) async {
    try {
      final listenerId = _getListenerId();

      final now = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(radioId).set({
        'active_listeners': FieldValue.arrayRemove([listenerId]),
        'app_last_decrement': now,
        'last_app_activity': now,
      }, SetOptions(merge: true));

      StoyCoLogger.info(
        '[RadioService] Listener $listenerId removed from active listeners for radio $radioId',
      );
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error removing user from active listeners',
        error: e,
      );
    }
  }

  /// Watches the real-time listener count for a radio.
  ///
  /// [radioId] The radio document ID.
  /// Returns a [Stream] that emits the current unique listener count.
  /// Counts the number of unique user IDs in the `active_listeners` array.
  Stream<int> watchListenerCount(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        if (data == null) return 0;

        final activeListeners = data['active_listeners'] as List<dynamic>?;
        return activeListeners?.length ?? 0;
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
