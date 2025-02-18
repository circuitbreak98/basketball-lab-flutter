import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/auth/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff6750a4), 
            brightness: Brightness.dark, //다크/라이트 모드 선택 
            ),
        useMaterial3: true,
        textTheme: GoogleFonts.archivoTextTheme(
          ThemeData.dark().textTheme,
        ),
        primaryTextTheme: GoogleFonts.archivoTextTheme(
          ThemeData.dark().primaryTextTheme,
        ),
      ),
      builder: (context, child) {
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const LoginView(),
    );
  }
}
