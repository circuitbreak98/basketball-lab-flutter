import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_constants.dart';
import '../../models/video_model.dart';
import '../../services/admin_service.dart';
import '../../widgets/youtube_thumbnail.dart';

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
    final hasAccess = await _adminService.hasRole('admin');
    if (!hasAccess && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppConstants.accessDeniedMessage)),
      );
    }
  }

  Future<void> _addVideo() async {
    if (_titleController.text.isEmpty || _videoIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppConstants.videoRequiredMessage)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.featuredVideosPath)
          .add({
        AppConstants.titleField: _titleController.text,
        AppConstants.videoIdField: _videoIdController.text,
        AppConstants.videoDescriptionField: _descriptionController.text,
        AppConstants.dateCreatedField: FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _videoIdController.clear();
      _descriptionController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.videoAddedMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppConstants.errorLoadingMessage)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVideo(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.featuredVideosPath)
          .doc(id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.videoDeletedMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppConstants.errorLoadingMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.videoManagementTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: AppConstants.videoTitleLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _videoIdController,
                  decoration: const InputDecoration(
                    labelText: AppConstants.videoIdLabel,
                    border: OutlineInputBorder(),
                    helperText: AppConstants.videoIdHelper,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: AppConstants.videoDescriptionLabel,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addVideo,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(AppConstants.videoAddButtonLabel),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(AppConstants.featuredVideosPath)
                  .orderBy(AppConstants.dateCreatedField, descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(AppConstants.errorLoadingMessage));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final videos = snapshot.data!.docs
                    .map((doc) => VideoModel.fromFirestore(doc))
                    .toList();

                if (videos.isEmpty) {
                  return Center(child: Text(AppConstants.noVideosMessage));
                }

                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 120,
                        height: 90,
                        child: YouTubeThumbnail(
                          videoId: video.videoId,
                          width: 120,
                          height: 90,
                        ),
                      ),
                      title: Text(video.title),
                      subtitle: Text(video.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: AppConstants.videoDeleteTooltip,
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
