import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collectionName = "profiles";

  Future<ProfileModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      
      if (!doc.exists) {
        // Create new profile if it doesn't exist
        final user = _auth.currentUser;
        if (user != null) {
          final newProfile = ProfileModel(
            uid: uid,
            displayName: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL ?? '',
            joinDate: Timestamp.now(),
          );
          await _firestore.collection(_collectionName).doc(uid).set(newProfile.toJson());
          return newProfile;
        }
        return null;
      }

      return ProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile(ProfileModel profile) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(profile.uid)
          .update(profile.toJson());
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  Future<bool> updatePostCount(String uid, {bool increment = true}) async {
    try {
      await _firestore.collection(_collectionName).doc(uid).update({
        'postCount': FieldValue.increment(increment ? 1 : -1),
      });
      return true;
    } catch (e) {
      print('Error updating post count: $e');
      return false;
    }
  }
} 