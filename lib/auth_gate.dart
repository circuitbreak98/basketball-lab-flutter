import 'package:basketball_lab_flutter/maintabView.dart';
import 'package:basketball_lab_flutter/postListView.dart';
import 'package:basketball_lab_flutter/postView.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
import 'package:flutter/material.dart';

import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {3
        return snapshot.hasData
            ? const MainTabView()
            : SignInScreen(
                providers: [
                  EmailAuthProvider(),
                  GoogleProvider(
                      clientId:
                          "890905270534-k5m8he0tvq6sldq7agdt0gc0ef3r1581.apps.googleusercontent.com"), // new
                ],
                headerBuilder: (context, constraints, shrinkOffset) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset('flutterfire_300x.png'),
                    ),
                  );
                },
                subtitleBuilder: (context, action) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: action == AuthAction.signIn
                        ? const Text('Welcome to FlutterFire, please sign in!')
                        : const Text('Welcome to Flutterfire, please sign up!'),
                  );
                },
                footerBuilder: (context, action) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'By signing in, you agree to our terms and conditions.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
                sideBuilder: (context, shrinkOffset) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset('flutterfire_300x.png'),
                    ),
                  );
                },
              );
      },
    );
  }
}
