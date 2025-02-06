import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = "featured_videos";

  Future<List<VideoModel>> getFeaturedVideos() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      return snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting featured videos: $e');
      return [];
    }
  }
} 