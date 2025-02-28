import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment_model.dart';

abstract class BaseCommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get collectionPath;

  Future<void> addComment(String postId, String text) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final commentData = {
      'text': text.trim(),
      'authorId': user.uid,
      'authorName': user.displayName ?? 'Anonymous',
      'dateCreated': Timestamp.now(),
    };

    final batch = _firestore.batch();
    
    // Add comment
    final commentRef = _firestore
        .collection(collectionPath)
        .doc(postId)
        .collection('comments')
        .doc();
    batch.set(commentRef, commentData);

    // Update comment count
    final postRef = _firestore.collection(collectionPath).doc(postId);
    batch.update(postRef, {'commentCount': FieldValue.increment(1)});

    await batch.commit();
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection(collectionPath)
        .doc(postId)
        .collection('comments')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromFirestore(doc))
            .toList());
  }
} 