import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';

mixin BaseReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reportContent({
    required String contentId,
    required ReportType type,
    required String reason,
    required String contentPreview,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('reports').add({
      'contentId': contentId,
      'type': type.toString(),
      'reportedBy': user.email,
      'reason': reason,
      'dateReported': Timestamp.now(),
      'isResolved': false,
      'contentPreview': contentPreview,
    });
  }
} 