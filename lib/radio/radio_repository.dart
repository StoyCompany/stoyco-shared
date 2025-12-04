import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoyco_shared/models/radio_model.dart';

/// Repository for accessing radios from Firestore.
///
/// Read-only - The app should NOT modify radio data,
/// only tracking fields.
class RadioRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'radios';

  RadioRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Gets all active radios ordered by creation date.
  Stream<List<RadioModel>> getActiveRadios() => _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RadioModel.fromFirestore(doc))
            .toList());

  /// Gets radios by partner.
  Stream<List<RadioModel>> getRadiosByPartner(String partnerId) => _firestore
        .collection(_collection)
        .where('communityOwnerId', isEqualTo: partnerId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RadioModel.fromFirestore(doc))
            .toList());

  /// Gets a radio by ID (single snapshot).
  Future<RadioModel?> getRadioById(String radioId) async {
    final doc = await _firestore.collection(_collection).doc(radioId).get();
    return doc.exists ? RadioModel.fromFirestore(doc) : null;
  }

  /// Listens to changes in a specific radio (stream).
  Stream<RadioModel?> watchRadio(String radioId) => _firestore
        .collection(_collection)
        .doc(radioId)
        .snapshots()
        .map((doc) => doc.exists ? RadioModel.fromFirestore(doc) : null);

  /// Gets the real-time listener count stream.
  Stream<int> watchListenerCount(String radioId) => _firestore
        .collection(_collection)
        .doc(radioId)
        .snapshots()
        .map((doc) => doc.data()?['members_online_count'] ?? 0);

  /// Gets all radios (no status filter) - useful for admin.
  Stream<List<RadioModel>> getAllRadios() => _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RadioModel.fromFirestore(doc))
            .toList());
}
