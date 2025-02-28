import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_constants.dart';
import '../../models/report_model.dart';
import '../../models/general_board_model.dart';
import '../../models/guest_board_model.dart';
import '../../views/general_board/general_board_detail_view.dart';
import '../../views/guest_board/guest_board_detail_view.dart';
import '../../utils/date_utils.dart';

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text(AppConstants.reportedContentTitle)),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(AppConstants.reportsPath)
                .where(AppConstants.isResolvedField, isEqualTo: false)
                .orderBy(AppConstants.dateCreatedField, descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(AppConstants.errorLoadingMessage));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final reports = snapshot.data!.docs
                  .map((doc) => ReportModel.fromFirestore(doc))
                  .toList();

              if (reports.isEmpty) {
                return const Center(child: Text(AppConstants.noReportedContent));
              }

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        '${AppConstants.reportedTypeLabel}${report.type.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppConstants.reasonLabel}${report.reason}'),
                          Text('${AppConstants.contentLabel}${report.contentPreview}'),
                          Text(
                            '${AppConstants.reportDateLabel}${report.formattedDate}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            tooltip: AppConstants.viewContentTooltip,
                            onPressed: () => _viewContent(context, report),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            tooltip: AppConstants.resolveReportTooltip,
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

  Future<void> _resolveReport(ReportModel report) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.reportsPath)
        .doc(report.id)
        .update({AppConstants.isResolvedField: true});
  }

  Future<void> _viewContent(BuildContext context, ReportModel report) async {
    if (report.type == ReportType.post) {
      String collectionPath;
      Widget Function(dynamic) createDetailView;

      if (await _isGeneralBoardPost(report.contentId)) {
        collectionPath = '${AppConstants.categoriesPath}/${AppConstants.generalBoard}/${AppConstants.postsPath}';
        createDetailView = (post) => GeneralBoardDetailView(post: post);
      } else {
        collectionPath = '${AppConstants.categoriesPath}/${AppConstants.guestBoard}/${AppConstants.postsPath}';
        createDetailView = (post) => GuestBoardDetailView(post: post);
      }

      final postDoc = await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(report.contentId)
          .get();

      if (postDoc.exists && context.mounted) {
        final post = collectionPath.contains(AppConstants.generalBoard)
            ? GeneralBoardModel.fromFirestore(postDoc)
            : GuestBoardModel.fromFirestore(postDoc);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => createDetailView(post),
          ),
        );
      }
    }
  }

  Future<bool> _isGeneralBoardPost(String postId) async {
    final doc = await FirebaseFirestore.instance
        .collection('${AppConstants.categoriesPath}/${AppConstants.generalBoard}/${AppConstants.postsPath}')
        .doc(postId)
        .get();
    return doc.exists;
  }
}
