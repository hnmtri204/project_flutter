import 'package:flutter/material.dart';
import 'package:myapp/controllers/appwrite_controllers.dart';
import 'package:myapp/views/chat_page.dart';
import 'package:myapp/views/home.dart';
import 'package:myapp/views/phone_login.dart';
import 'package:myapp/views/profile.dart';
import 'package:myapp/views/search_users.dart';
import 'package:myapp/views/update_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => CheckUserSessions(),
        "/login": (context) => PhoneLogin(),
        "/home": (context) => HomePage(),
        "/chat": (context) => ChatPage(),
        "/profile": (context) => ProfilePage(),
        "/update": (context) => UpdateProfile(),
        "/search": (context) => SearchUsers(),
      },
    );
  }
}

class CheckUserSessions extends StatefulWidget {
  const CheckUserSessions({super.key});

  @override
  State<CheckUserSessions> createState() => _CheckUserSessionsState();
}

class _CheckUserSessionsState extends State<CheckUserSessions> {
  @override
  void initState() {
    checkSessions().then((value) {
      if (value) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
