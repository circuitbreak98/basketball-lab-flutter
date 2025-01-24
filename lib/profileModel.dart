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

  factory ProfileModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProfileModel(
      uid: documentId,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
