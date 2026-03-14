import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('वापरकर्ता मिळविण्यात अयशस्वी: $e');
    }
  }

  Future<void> createUser(AppUser user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception('वापरकर्ता तयार करण्यात अयशस्वी: $e');
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(user.toMap());
    } catch (e) {
      throw Exception('वापरकर्ता अपडेट करण्यात अयशस्वी: $e');
    }
  }

  Stream<AppUser?> getUserStream(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }
}