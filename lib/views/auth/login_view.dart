import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import '../main_tab_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainTabView();
        }

        return SignInScreen(
          showAuthActionSwitch: false,
          subtitleBuilder: (context, action) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Please sign in to continue'),
            );
          },
          providers: [
            GoogleProvider(
              clientId: "890905270534-k5m8he0tvq6sldq7agdt0gc0ef3r1581.apps.googleusercontent.com",
            ),
            EmailAuthProvider(),
          ],
          footerBuilder: (context, action) {
            return const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'By signing in, you agree to our terms and conditions.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
          styles: const {
            EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
          },
        );
      },
    );
  }
} 