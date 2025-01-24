/// profileRepository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basketball_lab_flutter/profileModel.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieve the profile for the given user ID
  Future<ProfileModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return ProfileModel.fromMap(doc.data()!, doc.id);
      } else {
        return null; // Document does not exist
      }
    } catch (e) {
      // Handle the error, log it, etc.
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Optional: create or update a user profile
  Future<void> setUserProfile(ProfileModel profile) async {
    try {
      await _firestore.collection('users').doc(profile.uid).set({
        'displayName': profile.displayName,
        'email': profile.email,
        'photoUrl': profile.photoUrl,
      });
    } catch (e) {
      print('Error setting user profile: $e');
    }
  }
}
