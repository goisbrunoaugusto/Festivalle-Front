// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/components/my_multiline_text_field.dart';
import '../components/my_textfield.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

List<String> list = <String>['festeiro', 'organizador', 'vendedor'];

Future<void> registerUserJson(
    String name,
    String password,
    String email,
    String role,
    String phone,
    String cpf,
    String vendedorDescription,
    String organizadorCargo,
    BuildContext context) async {
  var url = Uri.parse("http://10.0.2.2:8080/user");
  var response = await http.post(url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, Object>{
        "name": name,
        "password": password,
        "email": email,
        "cpf": cpf,
        "phone": phone,
        "type": role,
        "vendedorDescription": vendedorDescription ?? "",
        "organizadorCargo": organizadorCargo ?? ""
      }));
  if (response.statusCode == 201) {
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
  final vendedorController = TextEditingController();
  final organizadorController = TextEditingController();
  String dropdownValue = list.first;

  void registerUser() {
    registerUserJson(
        usernameController.text,
        passwordController.text,
        emailController.text,
        dropdownValue,
        phoneController.text,
        cpfController.text,
        vendedorController.text,
        organizadorController.text,
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title:
            const Text('Register Page', style: TextStyle(color: Colors.white)),
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
                hintText: 'Digite seu cpf',
                obscuredText: false,
                controller: cpfController,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("Selecione o tipo de usuario.",
                  style: TextStyle(color: Colors.white, fontSize: (20))),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  hint: const Text("Selecione uma função",
                      style: TextStyle(color: Colors.white, fontSize: (20))),
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              if (dropdownValue == 'vendedor') ...[
                MyMultilineTextField(
                    hintText: "Digite a descrição do vendedor",
                    controller: vendedorController),
                const SizedBox(
                  height: 50,
                ),
              ],
              if (dropdownValue == 'organizador') ...[
                MyTextField(
                    hintText: "Digite a descrição do organizador",
                    obscuredText: false,
                    controller: organizadorController),
                const SizedBox(
                  height: 50,
                ),
              ],
              MyButton(buttonText: 'Register', buttonFunction: registerUser),
            ]),
          ),
        ),
      ),
    );
  }
}
