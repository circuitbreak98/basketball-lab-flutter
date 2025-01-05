import 'package:basketball_lab_flutter/loginTest.dart';
import 'package:basketball_lab_flutter/postTestView.dart';
import 'package:basketball_lab_flutter/postView.dart';
import 'package:flutter/material.dart';
import 'package:basketball_lab_flutter/storeTest.dart';
import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //home: const LoginTestView(),
        //home: LoginTestView(),
        //home: PostView(),
        home: AuthGate());
  }
}
