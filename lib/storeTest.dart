import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_storage/firebase_storage.dart';
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