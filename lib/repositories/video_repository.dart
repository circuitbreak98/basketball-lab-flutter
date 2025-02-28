import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';
import '../constants/app_constants.dart';

class VideoRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<VideoModel>> getFeaturedVideosStream() {
    return _firestore
        .collection(AppConstants.featuredVideosPath)
        .orderBy(AppConstants.dateCreatedField, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VideoModel.fromFirestore(doc))
            .toList());
  }
} 