import 'package:flutter/material.dart';
import '../../models/base_board_model.dart';
import '../../repositories/base_board_repository.dart';

abstract class BaseBoardListView<T extends BaseBoardModel> extends StatefulWidget {
  const BaseBoardListView({super.key});

  @override
  BaseBoardListViewState<T> createState();
}

abstract class BaseBoardListViewState<T extends BaseBoardModel> extends State<BaseBoardListView<T>> {
  List<T> _posts = [];
  bool _isLoading = false;

  BaseBoardRepository<T> get repository;
  String get boardTitle;
  Widget Function(T) get createDetailView;

  Future<void> _loadAllPosts() async {
    setState(() => _isLoading = true);

    try {
      final posts = await repository.getAllPosts();
      setState(() => _posts = posts);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(boardTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.post_add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => createWriteView(
                    onPostCreated: () => _loadAllPosts(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.comment, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${post.commentCount ?? 0}'),
                                ],
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => createDetailView(post),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget createWriteView({required VoidCallback onPostCreated});
} 