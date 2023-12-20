import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percobaan2/screen/auth/login.dart';
import 'package:percobaan2/screen/tugas_scr.dart';

class UserState extends StatefulWidget {
  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            print("user is not signed in yet");
            return Login();
          } else if (userSnapshot.hasData) {
            return TasksScreen();
          } else if (userSnapshot.hasError) {
            print("user is already signed in");
            return Scaffold(
              body: Center(
                child: Text("An error has been accured"),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text("something went wrong"),
            ),
          );
        });
  }
}
