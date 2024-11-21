import 'userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionName = "users";

  Future<bool> addUser(UserModel user) async {
    await _firestore
        .collection(_collectionName)
        .doc(user.uid)
        .set(user.toJson());
    return true;
  }

  Future<bool> removeUser(UserModel user) async {
    try {
      await _firestore.collection(_collectionName).doc(user.uid).delete();
      return true;
    } catch (e) {
      print('Error removing user: $e');
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(user.uid)
          .update(user.toJson());
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(uid).get();

      if (doc.exists) {
        return UserModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error retrieving user: $e');
      throw Exception('Error retrieving user');
    }
  }
}
