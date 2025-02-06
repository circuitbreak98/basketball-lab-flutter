import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final DateTime dateCreated;

  CommentModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.dateCreated,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      text: data['text'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'dateCreated': Timestamp.fromDate(dateCreated),
    };
  }
}
