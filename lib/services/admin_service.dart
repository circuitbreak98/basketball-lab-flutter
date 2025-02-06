import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin_model.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AdminModel? _cachedAdmin;

  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('DEBUG: No user logged in');
      return false;
    }

    try {
      if (_cachedAdmin != null) {
        print('DEBUG: Using cached admin data');
        return true;
      }

      print('DEBUG: Checking admin document for email: ${user.email}');
      final doc = await _firestore
          .collection('admins')
          .doc(user.email)
          .get();

      if (!doc.exists) {
        print('DEBUG: No admin document found');
        return false;
      }

      print('DEBUG: Admin document found: ${doc.data()}');
      _cachedAdmin = AdminModel.fromJson(doc.data()!);
      return true;
    } catch (e) {
      print('DEBUG: Error checking admin status: $e');
      return false;
    }
  }

  Future<bool> hasRole(String role) async {
    if (!await isAdmin()) {
      print('DEBUG: User is not an admin');
      return false;
    }
    final hasRole = _cachedAdmin?.hasRole(role) ?? false;
    print('DEBUG: Checking role "$role": $hasRole');
    return hasRole;
  }

  void clearCache() {
    _cachedAdmin = null;
  }
}
