import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/date_utils.dart';
import '../constants/app_constants.dart';

class CommentModel {
  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final Timestamp? dateCreated;

  CommentModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    this.dateCreated,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      text: data['text'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      dateCreated: data['dateCreated'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'dateCreated': dateCreated,
    };
  }

  String get formattedDate {
    return dateCreated != null ? AppDateUtils.formatDate(dateCreated!) : AppConstants.noDateText;
  }
}
