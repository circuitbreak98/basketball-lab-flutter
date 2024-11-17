import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new

class LoginTestView extends StatelessWidget {
  const LoginTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [
                GoogleProvider(
                    clientId:
                        "890905270534-k5m8he0tvq6sldq7agdt0gc0ef3r1581.apps.googleusercontent.com"), // new
              ],
            );
          } else {
            return SignOutButton();
          }
        });
  }
}

// #class UserRepository {
//     final userName;
//     Future<void> removeUser() {}
//     Future<void> loginUser() {}
//     Future<void> rateuser() {}
// }

// class PostRepositry {
//     void makePost(title,conntent) {}
//}
