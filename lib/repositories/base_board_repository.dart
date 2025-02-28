import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/base_board_model.dart';

abstract class BaseBoardRepository<T extends BaseBoardModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get categoryPath;
  T Function(Map<String, dynamic>, String) get fromJson;
  T Function(String, String, String) get newPost;

  Future<bool> addPost(String title, String text) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      T post = newPost(title, text, user.email ?? 'anonymous');
      
      await _firestore
          .collection(categoryPath)
          .doc(post.id)
          .set(post.toJson());
      return true;
    } catch (e) {
      print('Error adding post: $e');
      return false;
    }
  }

  Future<List<T>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(categoryPath)
          .orderBy('dateCreated', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error retrieving posts: $e');
      throw Exception('Error retrieving posts');
    }
  }
} 