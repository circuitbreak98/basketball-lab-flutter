import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/comment_model.dart';
import '../../models/base_board_model.dart';
import '../../models/report_model.dart';
import '../../services/base_comment_service.dart';
import '../../services/base_report_service.dart';

abstract class BaseBoardCommentView<T extends BaseBoardModel> extends StatefulWidget {
  final T post;

  const BaseBoardCommentView({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  BaseBoardCommentViewState<T> createState();
}

abstract class BaseBoardCommentViewState<T extends BaseBoardModel> extends State<BaseBoardCommentView<T>> {
  final TextEditingController _commentController = TextEditingController();

  BaseCommentService get service;
  BaseReportService get reportService;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _commentController.text = '';
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<List<CommentModel>>(
            stream: service.getComments(widget.post.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data ?? [];

              return ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(comment.text),
                      subtitle: Text(comment.authorName),
                      trailing: IconButton(
                        icon: const Icon(Icons.flag_outlined, size: 16),
                        onPressed: () => _reportComment(context, comment),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _submitComment(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitComment(BuildContext context) async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      await service.addComment(widget.post.id, _commentController.text);
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting comment: $e')),
        );
      }
    }
  }

  Future<void> _reportComment(BuildContext context, CommentModel comment) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Comment'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for reporting',
            hintText: 'Please describe why you are reporting this comment',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Report'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        await reportService.reportContent(
          contentId: comment.id,
          type: ReportType.comment,
          reason: reasonController.text,
          contentPreview: comment.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment reported successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error reporting comment: $e')),
          );
        }
      }
    }
  }
} 