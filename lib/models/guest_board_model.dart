import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_board_model.dart';

class GuestBoardModel extends BaseBoardModel {
  GuestBoardModel({
    required super.id,
    required super.title,
    required super.text,
    required super.dateCreated,
    required super.author,
    super.commentCount,
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

  factory GuestBoardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GuestBoardModel(
      id: doc.id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      dateCreated: data['dateCreated'] ?? Timestamp.now(),
      author: data['author'] ?? '',
      commentCount: data['commentCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson();
} 