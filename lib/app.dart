import 'package:flutter/material.dart' hide ThemeData, ColorScheme;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'views/auth/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromColors(
          colors: {'accent': Color(0xFFFF9000)},
        ),
        radius: 12,
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
