import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/guest_board_model.dart';
import '../repositories/base_board_repository.dart';

class GuestBoardRepository extends BaseBoardRepository<GuestBoardModel> {
  @override
  String get categoryPath => "categories/guest_board/posts";

  @override
  GuestBoardModel Function(Map<String, dynamic>, String) get fromJson => 
      GuestBoardModel.fromJson;

  @override
  GuestBoardModel Function(String, String, String) get newPost => 
      (title, text, author) => GuestBoardModel.newPost(title, text, author);
} 