import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/date_utils.dart';

abstract class BaseBoardModel {
  String id;
  String title;
  String text;
  Timestamp dateCreated;
  String author;
  final int commentCount;

  BaseBoardModel({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.author,
    this.commentCount = 0,
  });

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

  static T fromJson<T extends BaseBoardModel>(Map<String, dynamic> data, String id, T Function(Map<String, dynamic>, String) fromJson) {
    return fromJson(data, id);
  }

  String get formattedDate {
    return AppDateUtils.formatDate(dateCreated);
  }
} 