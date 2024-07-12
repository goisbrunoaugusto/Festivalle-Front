import 'package:flutter/material.dart';
import 'package:projeto_eventos/pages/login_page.dart';
import 'package:projeto_eventos/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tema Flutter',
      theme: ThemeData(
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 55, 135, 100),
            secondary: const Color.fromARGB(255, 41, 190, 140)),
      ),
      home: const LoginPage(),
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => const RegisterPage(),
      },
    );
  }
}
