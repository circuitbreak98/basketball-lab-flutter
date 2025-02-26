import 'package:flutter/material.dart';
import '../../repositories/guest_board_repository.dart';

class GuestBoardWriteView extends StatefulWidget {
  final VoidCallback? onPostCreated;
  const GuestBoardWriteView({Key? key, this.onPostCreated}) : super(key: key);

  @override
  State<GuestBoardWriteView> createState() => _GuestBoardWriteViewState();
}

class _GuestBoardWriteViewState extends State<GuestBoardWriteView> {
  final GuestBoardRepository _repository = GuestBoardRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _titleController.text = '';
      _textController.text = '';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_titleController.text.trim().isEmpty || _textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and text are required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await _repository.addPost(_titleController.text.trim(), _textController.text.trim());
    
    if (success && mounted) {
      widget.onPostCreated?.call();
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create post')),
      );
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('Write a Post')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Post Title'),
                ),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(labelText: 'Post Text'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createPost,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Post'),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
} 