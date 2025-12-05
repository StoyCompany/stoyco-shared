import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/utils/logger.dart';

class RadioService {
  RadioService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'radios';

  Future<List<RadioModel>> getActiveRadios() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList();
  }

  Future<List<RadioModel>> getRadiosByPartner(String partnerId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('communityOwnerId', isEqualTo: partnerId)
        .where('status', isEqualTo: 'active')
        .get();
    return snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList();
  }

  Future<RadioModel?> getRadioById(String radioId) async {
    final doc = await _firestore.collection(_collection).doc(radioId).get();
    return doc.exists ? RadioModel.fromFirestore(doc) : null;
  }

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

  Stream<int> watchListenerCount(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) => doc.data()?['members_online_count'] ?? 0);
}
