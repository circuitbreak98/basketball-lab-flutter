import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

class AppDateUtils {
  static String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 