import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String title;
  String text;

  PostModel({
    required this.id,
    required this.title,
    required this.text,
  });

//   factory PostModel.fromJson(Map<String, dynamic> data, String id){
//     return PostModel(id: id,)
//   }

  factory PostModel.newPost(String title, String text) {
    String generatedId =
        FirebaseFirestore.instance.collection("Posts").doc().id;
    return PostModel(id: generatedId, title: title, text: text);
  }

  factory PostModel.fromJson(Map<String, dynamic> data, String id) {
    return PostModel(
        id: id, title: data['title'] ?? '', text: data['text'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
    };
  }
}
