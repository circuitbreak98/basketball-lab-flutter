class ProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;

  ProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, String uid) {
    return ProfileModel(
      uid: uid,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
