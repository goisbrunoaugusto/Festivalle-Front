import 'package:flutter/material.dart';
import 'package:projeto_eventos/pages/login_page.dart';

class Pages extends StatefulWidget {
  @override
  State<Pages> createState() {
    return _PagesState();
  }

  const Pages({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     home: LoginPage(),
  //   );
  // }
}

class _PagesState extends State<Pages> {
  var activeScreen = 'login-screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'login-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
