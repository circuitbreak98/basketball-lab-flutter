import 'package:flutter/material.dart';
import '../../models/general_board_model.dart';
import '../../repositories/general_board_repository.dart';
import 'general_board_write_view.dart';
import 'general_board_detail_view.dart';

class GeneralBoardListView extends StatefulWidget {
  const GeneralBoardListView({super.key});

  @override
  State<GeneralBoardListView> createState() => _GeneralBoardListViewState();
}

class _GeneralBoardListViewState extends State<GeneralBoardListView> {
  final GeneralBoardRepository _repository = GeneralBoardRepository();
  List<GeneralBoardModel> _posts = [];
  bool _isLoading = false;

  Future<void> _loadAllPosts() async {
    setState(() => _isLoading = true);

    try {
      final posts = await _repository.getAllPosts();
      setState(() => _posts = posts);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
          title: const Text("General Board"),
          actions: [
            IconButton(
              icon: const Icon(Icons.post_add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneralBoardWriteView(
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
                                  builder: (context) =>
                                      GeneralBoardDetailView(post: post),
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
} 