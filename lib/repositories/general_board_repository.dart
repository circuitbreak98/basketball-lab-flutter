import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/general_board_model.dart';
import '../repositories/base_board_repository.dart';

class GeneralBoardRepository extends BaseBoardRepository<GeneralBoardModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  String get categoryPath => "categories/general_board/posts";

  @override
  GeneralBoardModel Function(Map<String, dynamic>, String) get fromJson => 
      GeneralBoardModel.fromJson;

  @override
  GeneralBoardModel Function(String, String, String) get newPost => 
      (title, text, author) => GeneralBoardModel.newPost(title, text, author);

  Future<List<GeneralBoardModel>> getAllPosts() async {
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