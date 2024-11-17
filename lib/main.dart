import 'package:basketball_lab_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'app.dart';

// TODO(codelab user): Get API key
const clientId = 'YOUR_CLIENT_ID';
const REDIRECT_URI = 'http://localhost:8080';
const YOUR_NATIVE_APP_KEY = '277c3035b0e075c400ab833d6fb5d1a6';
const YOUR_JAVASCRIPT_APP_KEY = 'cb0c5032a1c8c4fedfc70d6a948f14ec';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // KakaoSdk.init(
  //   nativeAppKey: '${YOUR_NATIVE_APP_KEY}',
  //   javaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
  // );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
