import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collectionName = "posts";

  Future<bool> addPost(String title, String text) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      PostModel post = PostModel.newPost(
        title, 
        text,
        user.email ?? 'anonymous',  // Use current user's email
      );
      
      await _firestore
          .collection(_collectionName)
          .doc(post.id)
          .set(post.toJson());
      return true;
    } catch (e) {
      print('Error adding post: $e');
      return false;
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('dateCreated', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error retrieving posts: $e');
      throw Exception('Error retrieving posts');
    }
  }
} 