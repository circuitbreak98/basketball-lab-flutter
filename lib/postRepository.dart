import 'package:cloud_firestore/cloud_firestore.dart';
import 'postModel.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = "posts";

  // Create
  Future<bool> addPost(String title, String text) async {
    try {
      // Create a new PostModel instance with a generated ID
      PostModel post = PostModel.newPost(title, text);

      // Save the new post to Firestore
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

  // Read single post
  Future<PostModel> getPost(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return PostModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      print('Error retrieving post: $e');
      throw Exception('Error retrieving post');
    }
  }

  // Read all posts
  Future<List<PostModel>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('dateCreated', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error retrieving posts: $e');
      throw Exception('Error retrieving posts');
    }
  }

  // Update
  Future<bool> updatePost(PostModel post) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(post.id)
          .update(post.toJson());
      return true;
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  // Delete
  Future<bool> removePost(PostModel post) async {
    try {
      await _firestore.collection(_collectionName).doc(post.id).delete();
      return true;
    } catch (e) {
      print('Error removing post: $e');
      return false;
    }
  }

  // Get posts by user ID
  Future<List<PostModel>> getPostsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('dateCreated', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error retrieving user posts: $e');
      throw Exception('Error retrieving user posts');
    }
  }
}
