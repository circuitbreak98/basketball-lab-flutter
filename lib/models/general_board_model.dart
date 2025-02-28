import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_board_model.dart';

class GeneralBoardModel extends BaseBoardModel {
  GeneralBoardModel({
    required super.id,
    required super.title,
    required super.text,
    required super.dateCreated,
    required super.author,
    super.commentCount,
  });

  factory GeneralBoardModel.newPost(String title, String text, String authorEmail) {
    String generatedId = FirebaseFirestore.instance.collection("categories/general_board/posts").doc().id;
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

  @override
  Map<String, dynamic> toJson() => super.toJson();
} 