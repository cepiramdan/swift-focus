import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/user_state.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEEEEE),
      ),
      debugShowCheckedModeBanner: false,
      home: UserState(),
    );
  }
}
