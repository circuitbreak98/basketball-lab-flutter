import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Missing import

class StoreTestView extends StatelessWidget {
  StoreTestView({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> user = {
    "brand": "Genesis",
    "name": "G70",
    "price": 5000,
  };

  Future<void> _addUserToFirestore() async {
    try {
      DocumentReference doc = await _firestore.collection("users").add(user);
      print('DocumentSnapshot added with ID: ${doc.id}');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the Firestore operation when needed, not in build
    // For testing, you might want to use a button:
    return ElevatedButton(
      onPressed: _addUserToFirestore,
      child: const Text("Add User to Firestore"),
    );
  }
}
