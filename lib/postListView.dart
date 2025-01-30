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
import 'postWriteView.dart';

/// post test view를 post list view 하나 나누고, post write button view 로 나누기
/// 탭뷰가 post list view와 my profile view를 가지고 있어야함.

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //중첩 scaffold
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
            icon: Icon(Icons.post_add))
      ]),
      body: PostListSubView(),
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
      //print("$posts");
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
