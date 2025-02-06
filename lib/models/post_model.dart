import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String title;
  String text;
  Timestamp dateCreated;
  String author;

  PostModel({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.author,
  });

  factory PostModel.newPost(String title, String text, String authorEmail) {
    String generatedId = FirebaseFirestore.instance.collection("Posts").doc().id;
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'dateCreated': dateCreated,
      'author': author,
    };
  }
} 