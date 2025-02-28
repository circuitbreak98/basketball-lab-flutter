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
    if (user == null) return false;

    try {
      if (_cachedAdmin != null) return true;

      final doc = await _firestore
          .collection('admins')
          .doc(user.email)
          .get();

      if (!doc.exists) return false;

      _cachedAdmin = AdminModel.fromJson(doc.data()!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasRole(String role) async {
    if (!await isAdmin()) return false;
    return _cachedAdmin?.hasRole(role) ?? false;
  }

  void clearCache() {
    _cachedAdmin = null;
  }
}
