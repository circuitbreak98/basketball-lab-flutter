import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/report_model.dart';
import '../post/post_detail_view.dart';
import '../../models/post_model.dart';

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('Reported Content')),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reports')
                .where('isResolved', isEqualTo: false)
                .orderBy('dateReported', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final reports = snapshot.data!.docs
                  .map((doc) => ReportModel.fromFirestore(doc))
                  .toList();

              if (reports.isEmpty) {
                return const Center(child: Text('No reported content'));
              }

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        'Reported ${report.type.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reason: ${report.reason}'),
                          Text('Content: ${report.contentPreview}'),
                          Text(
                            'Reported on: ${_formatDate(report.dateReported)}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () => _viewContent(context, report),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () => _resolveReport(report),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _resolveReport(ReportModel report) async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(report.id)
        .update({'isResolved': true});
  }

  Future<void> _viewContent(BuildContext context, ReportModel report) async {
    if (report.type == ReportType.post) {
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(report.contentId)
          .get();

      if (postDoc.exists && context.mounted) {
        final post = PostModel.fromFirestore(postDoc);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailView(post: post),
          ),
        );
      }
    }
    // TODO: Implement comment viewing
  }
}
