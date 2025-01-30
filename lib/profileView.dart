import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basketball_lab_flutter/profileRepository.dart';
import 'package:basketball_lab_flutter/profileModel.dart';

/// profileView.dart
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileRepository _repository = ProfileRepository();
  bool _isLoading = true;
  ProfileModel? _profile;
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _repository.getCurrentUserProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });

      if (profile == null || profile.displayName.isEmpty) {
        // Show username setup dialog if no profile or no display name
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showUsernameDialog();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _showUsernameDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Your Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter your username',
              labelText: 'Username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_usernameController.text.isNotEmpty) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final newProfile = ProfileModel(
                        uid: user.uid,
                        displayName: _usernameController.text,
                        email: user.email ?? '',
                        photoUrl: user.photoURL ?? '',
                      );
                      await _repository.setUserProfile(newProfile);
                      setState(() {
                        _profile = newProfile;
                      });
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Username updated successfully')),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating username: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
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
          CircleAvatar(
            radius: 40,
            backgroundImage: _profile?.photoUrl != null && _profile!.photoUrl.isNotEmpty
                ? NetworkImage(_profile!.photoUrl)
                : null,
            child: _profile?.photoUrl == null || _profile!.photoUrl.isEmpty
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _profile!.displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(_profile!.email),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showUsernameDialog();
            },
            child: const Text('Change Username'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
