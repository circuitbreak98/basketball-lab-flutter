import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'userModel.dart';
import 'userRepository.dart'; // Missing import

class StoreTestView extends StatelessWidget {
  StoreTestView({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> user = {
    "brand": "Genesis",
    "name": "G70",
    "price": 5000,
  };

  Future<void> _createUserToFirestore() async {
    try {
      await _firestore.collection("users").doc("111").set(user);
      print('DocumentSnapshot added with ID: ${"111"}');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<void> _userRespositoryTest() async {
    final repo = UserRepository();
    final user =
        UserModel(uid: "test_uid", name: "test_name", postIds: ["1", "2", "3"]);
    await repo.addUser(user);
    final retrived = await repo.getUser("test_uid");
    print("retrived: ${retrived.name}");
  }

  // void _readUserToFirestore() async{
  //   try{
  //     DocumentReference doc = await _firestore.collection("users").
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Call the Firestore operation when needed, not in build
    // For testing, you might want to use a button:
    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: _readUserToFirestore,
        //   child: const Text("")),
        ElevatedButton(
          onPressed: _userRespositoryTest,
          child: const Text("Add User to Firestore"),
        ),
      ],
    );
  }
}
