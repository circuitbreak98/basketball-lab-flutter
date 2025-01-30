import 'package:basketball_lab_flutter/postRepository.dart';
import 'package:flutter/material.dart';

import 'postRepository.dart';

class PostWriteView extends StatefulWidget {
  const PostWriteView({Key? key}) : super(key: key);

  @override
  State<PostWriteView> createState() => _PostWriteViewState();
}

class _PostWriteViewState extends State<PostWriteView> {
  final PostRepository repository = PostRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createPost() async {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();

    if (title.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and text are required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await repository.addPost(title, text);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );
      _titleController.clear();
      _textController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create post')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
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
        ]),
      ),
    );
  }
}
