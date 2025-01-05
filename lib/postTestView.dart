import 'package:basketball_lab_flutter/postModel.dart';
import 'package:basketball_lab_flutter/postRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:flutter/material.dart';
import 'postModel.dart';
import 'postRepository.dart';

import 'package:flutter/material.dart';
import 'postModel.dart';
import 'postRepository.dart';

class PostTestView extends StatefulWidget {
  const PostTestView({Key? key}) : super(key: key);

  @override
  State<PostTestView> createState() => _PostTestViewState();
}

class _PostTestViewState extends State<PostTestView> {
  final PostRepository repository = PostRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<PostModel> _posts = [];
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
      await _loadAllPosts(); // Refresh the list after adding a post
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create post')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadAllPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await repository.getAllPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Test View')),
      body: Padding(
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _posts.isEmpty
                      ? const Center(child: Text('No posts available'))
                      : ListView.builder(
                          itemCount: _posts.length,
                          itemBuilder: (context, index) {
                            final post = _posts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.text),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
