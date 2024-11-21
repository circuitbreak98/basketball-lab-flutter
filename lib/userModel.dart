class UserModel {
  String uid;
  String name;
  List<String> postIds;

  UserModel({
    required this.uid,
    required this.name,
    required this.postIds,
  });

  // Factory constructor to create a UserModel instance from Firestore data
  factory UserModel.fromJson(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      name: data['name'] ?? '', // Default to an empty string if null
      postIds: List<String>.from(
          data['postIds'] ?? []), // Default to an empty list if null
    );
  }

  // Method to convert UserModel to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'postIds': postIds,
    };
  }
}
