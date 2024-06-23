// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/model/user_model.dart';
import '../components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/components/my_multi_selection_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

Future<UserModel?> registerUserJson(String name, String password, String email,
    List roles, String phone, String cpf, BuildContext context) async {
  var url = Uri.parse("http://10.0.2.2:8080/auth/signup");
  var response = await http.post(url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, Object>{
        "username": name,
        "password": password,
        "email": email,
        "cpf": cpf,
        "phone": phone ?? "",
        "roles": roles,
      }));
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyAlertDialog(
          title: 'Sucesso!',
          content: "Registro realizado com sucesso!",
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyAlertDialog(
          title: 'Ops!',
          content: "Nao foi possivel realizar seu registro.",
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cpfController = TextEditingController();
  final roleController = TextEditingController();
  final List<String> roles = [""];
  final multiSelectionBoxController = MultiSelectController();

  void registerUser() {
    List<dynamic> roles = multiSelectionBoxController.selectedOptions;
    List roles2 = [];
    roles.forEach((element) {
      roles2.add(element.value);
    });

    registerUserJson(
        usernameController.text,
        passwordController.text,
        emailController.text,
        roles2,
        phoneController.text,
        cpfController.text,
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              MyTextField(
                hintText: 'Digite seu nome',
                obscuredText: false,
                controller: usernameController,
              ),
              MyTextField(
                hintText: 'Digite seu email',
                obscuredText: false,
                controller: emailController,
              ),
              MyTextField(
                hintText: 'Digite sua senha',
                obscuredText: true,
                controller: passwordController,
              ),
              MyTextField(
                hintText: 'Digite seu telefone',
                obscuredText: false,
                controller: phoneController,
              ),
              MyTextField(
                hintText: 'Digite seu endereco',
                obscuredText: false,
                controller: addressController,
              ),
              MyTextField(
                hintText: 'Digite seu cpf',
                obscuredText: false,
                controller: cpfController,
              ),
              const SizedBox(
                height: 25,
              ),
              MyMultiSelectionBox(
                  controller: multiSelectionBoxController,
                  items: const <String, String>{
                    'Usuario': 'ROLE_USER',
                    'Organizador': 'ROLE_ORGANIZER'
                  }),
              // MyTextField(
              //   hintText: 'Digite sua role',
              //   obscuredText: false,
              //   controller: roleController,
              // ),
              const SizedBox(
                height: 50,
              ),
              MyButton(buttonText: 'Register', buttonFunction: registerUser),
            ]),
          ),
        ),
      ),
    );
  }
}
