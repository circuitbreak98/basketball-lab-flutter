import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/general_board_model.dart';

class GeneralBoardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _categoryPath = "categories/general_board/posts";

  Future<bool> addPost(String title, String text) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      GeneralBoardModel post = GeneralBoardModel.newPost(
        title, 
        text,
        user.email ?? 'anonymous',
      );
      
      await _firestore
          .collection(_categoryPath)
          .doc(post.id)
          .set(post.toJson());
      return true;
    } catch (e) {
      print('Error adding post: $e');
      return false;
    }
  }

  Future<List<GeneralBoardModel>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_categoryPath)
          .orderBy('dateCreated', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => GeneralBoardModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error retrieving posts: $e');
      throw Exception('Error retrieving posts');
    }
  }
} 