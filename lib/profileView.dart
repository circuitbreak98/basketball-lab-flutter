import 'package:flutter/material.dart';

/// profileView.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basketball_lab_flutter/profileRepository.dart';
import 'package:basketball_lab_flutter/profileModel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileRepository _repository = ProfileRepository();
  // ProfileModel? _profile;
  bool _isLoading = false;
  ProfileModel? _profile = ProfileModel(
      uid: "test",
      displayName: "displayName",
      email: "email",
      photoUrl: "https://images.app.goo.gl/dStSuYMTEfajzMDj8");

  @override
  void initState() {
    super.initState();
    // _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _repository.getUserProfile(user.uid);
      setState(() {
        // _profile = profile;
        _isLoading = false;
      });
    } else {
      // No user is signed in
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profile == null) {
      return const Center(child: Text('No profile data found.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_profile != null)
            // Profile photo
            CircleAvatar(radius: 40, child: const Icon(Icons.person, size: 40)),
          const SizedBox(height: 16),
          // Display Name
          Text(
            _profile!.displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Email
          Text(_profile!.email),
          const SizedBox(height: 16),

          // Add more fields or user actions as you see fit
          ElevatedButton(
            onPressed: () async {
              // If you allow the user to update or sign out
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
