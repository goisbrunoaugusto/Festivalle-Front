// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_textfield.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  Future<void> loginUserJson(String username, String password) async {
    var url = Uri.parse("http://10.0.2.2:8080/user/login");
    var response = await http.post(url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          "email": username,
          "password": password,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(token: token)));
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return MyAlertDialog(
                title: 'Erro ao realizar login.', content: response.body);
          });
    }
  }

  void navigateRegister() async {
    Navigator.pushNamed(context, '/register');
  }

  void validation() {
    loginUserJson(usernameController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const Image(
                image: AssetImage('lib/assets/images/FUNDO_BRANCO.png'),
              ),
              MyTextField(
                  hintText: 'Digite seu email',
                  obscuredText: false,
                  controller: usernameController),
              MyTextField(
                  hintText: 'Digite sua senha',
                  obscuredText: true,
                  controller: passwordController),
              const SizedBox(
                height: 25,
              ),
              MyButton(buttonText: 'Log in', buttonFunction: validation),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                  buttonText: 'Registrar', buttonFunction: navigateRegister),
            ],
          ),
        ),
      ),
    );
  }
}
