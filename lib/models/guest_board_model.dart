import 'package:cloud_firestore/cloud_firestore.dart';

class GuestBoardModel {
  String id;
  String title;
  String text;
  Timestamp dateCreated;
  String author;
  final int commentCount;

  GuestBoardModel({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.author,
    this.commentCount = 0,
  });

  factory GuestBoardModel.newPost(String title, String text, String authorEmail) {
    String generatedId = FirebaseFirestore.instance.collection("categories/guest_board/posts").doc().id;
    return GuestBoardModel(
      id: generatedId,
      title: title,
      text: text,
      dateCreated: Timestamp.now(),
      author: authorEmail,
    );
  }

  factory GuestBoardModel.fromJson(Map<String, dynamic> data, String id) {
    return GuestBoardModel(
      id: id,
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