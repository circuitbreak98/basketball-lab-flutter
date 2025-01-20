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

/// post test view를 post list view 하나 나누고, post write button view 로 나누기
/// 탭뷰가 post list view와 my profile view를 가지고 있어야함.

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post List View"), actions: [
        IconButton(
            onPressed: () {
              // page route PostWriteView
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostWriteView(),
                ),
              );
            },
            icon: Icon(Icons.ac_unit))
      ]),
      body: PostListSubView(),
    );
  }
}

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
        appBar: AppBar(
          title: const Text('Post Test View'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.abc_sharp),
            )
          ],
        ),
        body: Padding(
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
            ])));
  }
}

class PostListSubView extends StatefulWidget {
  const PostListSubView({Key? key}) : super(key: key);

  @override
  State<PostListSubView> createState() => _PostListSubViewState();
}

class _PostListSubViewState extends State<PostListSubView> {
  final PostRepository repository = PostRepository();
  List<PostModel> _posts = [];
  bool _isLoading = false;

  Future<void> _loadAllPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await repository.getAllPosts();
      print("$posts");
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadAllPosts();
    // });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
