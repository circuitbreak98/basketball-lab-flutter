import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/date_utils.dart';

enum ReportType { post, comment }

class ReportModel {
  final String id;
  final String contentId;
  final ReportType type;
  final String reportedBy;
  final String reason;
  final Timestamp dateReported;
  final bool isResolved;
  final String? contentPreview;

  ReportModel({
    required this.id,
    required this.contentId,
    required this.type,
    required this.reportedBy,
    required this.reason,
    required this.dateReported,
    this.isResolved = false,
    this.contentPreview,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReportModel(
      id: doc.id,
      contentId: data['contentId'] ?? '',
      type: ReportType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => ReportType.post,
      ),
      reportedBy: data['reportedBy'] ?? '',
      reason: data['reason'] ?? '',
      dateReported: data['dateReported'] ?? Timestamp.now(),
      isResolved: data['isResolved'] ?? false,
      contentPreview: data['contentPreview'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'type': type.toString(),
      'reportedBy': reportedBy,
      'reason': reason,
      'dateReported': dateReported,
      'isResolved': isResolved,
      'contentPreview': contentPreview,
    };
  }

  String get formattedDate {
    return AppDateUtils.formatDate(dateReported);
  }
}
