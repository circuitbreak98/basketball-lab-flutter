import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String email;
  final List<String> roles;
  final Timestamp createdAt;

  AdminModel({
    required this.email,
    required this.roles,
    required this.createdAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'roles': roles,
      'createdAt': createdAt,
    };
  }

  bool hasRole(String role) => roles.contains(role);
} 