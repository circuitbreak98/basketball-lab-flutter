import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/date_utils.dart';
import '../constants/app_constants.dart';

class VideoModel {
  final String id;
  final String title;
  final String videoId;
  final String description;
  final Timestamp? dateCreated;

  VideoModel({
    required this.id,
    required this.title,
    required this.videoId,
    required this.description,
    this.dateCreated,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      videoId: data['videoId'] ?? '',
      description: data['description'] ?? '',
      dateCreated: data['dateCreated'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videoId': videoId,
      'description': description,
      'dateCreated': dateCreated,
    };
  }

  String get formattedDate {
    return dateCreated != null ? AppDateUtils.formatDate(dateCreated!) : AppConstants.noDateText;
  }
} 