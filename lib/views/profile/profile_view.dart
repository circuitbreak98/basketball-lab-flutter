import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/profile_model.dart';
import '../../repositories/profile_repository.dart';
import '../../views/admin/admin_video_view.dart';
import '../../services/admin_service.dart';
import '../admin/admin_reports_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileRepository _repository = ProfileRepository();
  final AdminService _adminService = AdminService();
  bool _isLoading = false;
  bool _isEditing = false;
  ProfileModel? _profile;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _checkAdminStatus();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile = await _repository.getUserProfile(user.uid);
        setState(() => _profile = profile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _adminService.isAdmin();
    //print('DEBUG: Is admin in profile: $isAdmin'); // Debug print
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Profile"),
          actions: [
            if (_profile != null)
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  setState(() => _isEditing = !_isEditing);
                  if (!_isEditing) {
                    // Save profile changes
                    _repository.updateProfile(_profile!);
                  }
                },
              ),
          ],
        ),
        if (_isLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Photo
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profile?.photoUrl.isNotEmpty == true
                            ? NetworkImage(_profile!.photoUrl)
                            : null,
                        child: _profile?.photoUrl.isEmpty == true
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      if (_isEditing)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              // TODO: Implement photo upload
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Display Name
                  if (_isEditing)
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Display Name'),
                      controller:
                          TextEditingController(text: _profile?.displayName),
                      onChanged: (value) {
                        if (_profile != null) {
                          setState(() {
                            _profile = _profile!.copyWith(displayName: value);
                          });
                        }
                      },
                    )
                  else
                    Text(
                      _profile?.displayName ?? 'No Name',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                  // Email
                  Text(
                    _profile?.email ?? 'No Email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  if (_isEditing)
                    TextField(
                      decoration: const InputDecoration(labelText: 'Bio'),
                      controller: TextEditingController(text: _profile?.bio),
                      maxLines: 3,
                      onChanged: (value) {
                        if (_profile != null) {
                          setState(() {
                            _profile = _profile!.copyWith(bio: value);
                          });
                        }
                      },
                    )
                  else if (_profile?.bio?.isNotEmpty == true)
                    Text(_profile!.bio),
                  const SizedBox(height: 16),

                  // Location
                  if (_isEditing)
                    TextField(
                      decoration: const InputDecoration(labelText: 'Location'),
                      controller:
                          TextEditingController(text: _profile?.location),
                      onChanged: (value) {
                        if (_profile != null) {
                          setState(() {
                            _profile = _profile!.copyWith(location: value);
                          });
                        }
                      },
                    )
                  else if (_profile?.location?.isNotEmpty == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        Text(_profile!.location),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Posts', _profile?.postCount ?? 0),
                      _buildStat('Joined', _formatDate(_profile?.joinDate)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign Out Button
                  ElevatedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text('Sign Out'),
                  ),

                  // Admin Button
                  if (_isAdmin)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminVideoView(),
                          ),
                        );
                      },
                      child: const Text('Manage Featured Videos'),
                    ),

                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminReportsView(),
                        ),
                      );
                    },
                    child: const Text('View Reported Content'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStat(String label, dynamic value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = timestamp.toDate();
    return '${date.month}/${date.year}';
  }
}
