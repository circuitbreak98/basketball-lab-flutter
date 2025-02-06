import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String bio;
  final String location;
  final Timestamp joinDate;
  final int postCount;
  final List<String> interests;

  ProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.bio = '',
    this.location = '',
    required this.joinDate,
    this.postCount = 0,
    this.interests = const [],
  });

  factory ProfileModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProfileModel(
      uid: documentId,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      bio: data['bio'] ?? '',
      location: data['location'] ?? '',
      joinDate: data['joinDate'] ?? Timestamp.now(),
      postCount: data['postCount'] ?? 0,
      interests: List<String>.from(data['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'location': location,
      'joinDate': joinDate,
      'postCount': postCount,
      'interests': interests,
    };
  }

  ProfileModel copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    String? location,
    List<String>? interests,
  }) {
    return ProfileModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      joinDate: joinDate,
      postCount: postCount,
      interests: interests ?? this.interests,
    );
  }
} 