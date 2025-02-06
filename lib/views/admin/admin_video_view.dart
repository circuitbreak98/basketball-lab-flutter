import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/video_model.dart';
import '../../services/admin_service.dart';

class AdminVideoView extends StatefulWidget {
  const AdminVideoView({Key? key}) : super(key: key);

  @override
  State<AdminVideoView> createState() => _AdminVideoViewState();
}

class _AdminVideoViewState extends State<AdminVideoView> {
  final _titleController = TextEditingController();
  final _videoIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    print('DEBUG: Checking admin access');
    final hasAccess = await _adminService.hasRole('admin');
    print('DEBUG: Has admin access: $hasAccess');
    if (!hasAccess && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access denied')),
      );
    }
  }

  Future<void> _addVideo() async {
    if (_titleController.text.isEmpty || _videoIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Video ID are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('featured_videos').add({
        'title': _titleController.text,
        'videoId': _videoIdController.text,
        'description': _descriptionController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _videoIdController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding video: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVideo(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('featured_videos')
          .doc(id)
          .delete();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting video: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Featured Videos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Video Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _videoIdController,
                  decoration: const InputDecoration(
                    labelText: 'YouTube Video ID',
                    border: OutlineInputBorder(),
                    helperText: 'Example: dQw4w9WgXcQ (from YouTube URL)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addVideo,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Video'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('featured_videos')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final videos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final data = video.data() as Map<String, dynamic>;
                    
                    return ListTile(
                      leading: Image.network(
                        'https://img.youtube.com/vi/${data['videoId']}/default.jpg',
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(data['description'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteVideo(video.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _videoIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 