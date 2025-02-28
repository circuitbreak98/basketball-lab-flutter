import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/general_board_model.dart';
import '../../models/report_model.dart';
import '../base/base_board_detail_view.dart';
import 'general_board_comment_view.dart';
import '../../services/base_report_service.dart';
import '../../services/general_board_service.dart';

class GeneralBoardDetailView extends BaseBoardDetailView<GeneralBoardModel> {
  GeneralBoardDetailView({super.key, required super.post});

  final GeneralBoardService _service = GeneralBoardService();

  @override
  Widget createCommentView(GeneralBoardModel post) => GeneralBoardCommentView(post: post);

  @override
  BaseReportService get reportService => _service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () => _showReportDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.text,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Author: ${post.author}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: ${post.dateCreated}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: createCommentView(post),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReportDialog(BuildContext context) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for reporting',
            hintText: 'Please describe why you are reporting this post',
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
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('reports').add({
          'contentId': post.id,
          'type': ReportType.post.toString(),
          'reportedBy': user.email,
          'reason': reasonController.text,
          'dateReported': Timestamp.now(),
          'isResolved': false,
          'contentPreview': post.title,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post reported successfully')),
          );
        }
      }
    }
  }
} 