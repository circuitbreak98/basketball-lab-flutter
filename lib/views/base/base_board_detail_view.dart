import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/base_board_model.dart';
import '../../models/report_model.dart';
import '../../services/base_report_service.dart';
import '../../utils/date_utils.dart';

abstract class BaseBoardDetailView<T extends BaseBoardModel> extends StatelessWidget {
  final T post;

  const BaseBoardDetailView({Key? key, required this.post}) : super(key: key);

  Widget createCommentView(T post);
  BaseReportService get reportService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            tooltip: AppConstants.reportPostTooltip,
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
              '${AppConstants.authorLabel}${post.author}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppConstants.dateLabel}${post.formattedDate}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              AppConstants.commentsTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
        title: const Text(AppConstants.reportPostTitle),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: AppConstants.reportReasonLabel,
            hintText: AppConstants.reportReasonHint,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppConstants.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppConstants.reportButtonLabel),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        await reportService.reportContent(
          contentId: post.id,
          type: ReportType.post,
          reason: reasonController.text,
          contentPreview: post.title,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppConstants.reportSuccessMessage)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppConstants.errorLoadingMessage)),
          );
        }
      }
    }
  }
} 