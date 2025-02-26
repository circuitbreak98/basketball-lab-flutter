import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralBoardModel {
  String id;
  String title;
  String text;
  Timestamp dateCreated;
  String author;
  final int commentCount;

  GeneralBoardModel({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.author,
    this.commentCount = 0,
  });

  factory GeneralBoardModel.newPost(String title, String text, String authorEmail) {
    String generatedId = FirebaseFirestore.instance.collection("general_board").doc().id;
    return GeneralBoardModel(
      id: generatedId,
      title: title,
      text: text,
      dateCreated: Timestamp.now(),
      author: authorEmail,
    );
  }

  factory GeneralBoardModel.fromJson(Map<String, dynamic> data, String id) {
    return GeneralBoardModel(
      id: id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      dateCreated: data['dateCreated'] ?? Timestamp.now(),
      author: data['author'] ?? '',
      commentCount: data['commentCount'] ?? 0,
    );
  }

  factory GeneralBoardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GeneralBoardModel(
      id: doc.id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      dateCreated: data['dateCreated'] ?? Timestamp.now(),
      author: data['author'] ?? '',
      commentCount: data['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'dateCreated': dateCreated,
      'author': author,
      'commentCount': commentCount,
    };
  }
} 