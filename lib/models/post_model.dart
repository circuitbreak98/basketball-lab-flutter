import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String title;
  String text;
  Timestamp dateCreated;
  String author;
  final int commentCount;

  PostModel({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.author,
    this.commentCount = 0,
  });

  factory PostModel.newPost(String title, String text, String authorEmail) {
    String generatedId =
        FirebaseFirestore.instance.collection("Posts").doc().id;
    return PostModel(
      id: generatedId,
      title: title,
      text: text,
      dateCreated: Timestamp.now(),
      author: authorEmail,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> data, String id) {
    return PostModel(
      id: id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      dateCreated: data['dateCreated'] ?? Timestamp.now(),
      author: data['author'] ?? '',
      commentCount: data['commentCount'] ?? 0,
    );
  }

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
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

  Map<String, dynamic> toMap() {
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
