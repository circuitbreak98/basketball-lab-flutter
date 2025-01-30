import 'package:flutter/material.dart';
import 'postModel.dart';
import 'postRepository.dart';
import 'postWriteView.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Parent Scaffold
      appBar: AppBar(
        title: const Text("Post List View"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to PostWriteView
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostWriteView(),
                ),
              );
            },
            icon: const Icon(Icons.post_add),
          ),
        ],
      ),
      body: const PostListSubView(),
    );
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                        subtitle: Text(
                          post.text,
                          maxLines: 1, // Show only first line as preview
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Navigate to PostDetailView when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailView(post: post),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

/// A simple Post Detail View
class PostDetailView extends StatelessWidget {
  final PostModel post;

  const PostDetailView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              /// Text
              Text(
                post.text,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              /// Example showing more post fields if needed
              Text(
                'Author: ${post.author}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              // You can add any other fields here like date, tags, etc.

              // Example "Created At" field
              Text(
                'Created At: ${post.dateCreated}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
