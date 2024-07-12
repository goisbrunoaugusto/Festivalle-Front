import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/pages/home_page.dart';

class EstabelecimentoCreationPage extends StatefulWidget {
  final String token;

  const EstabelecimentoCreationPage({super.key, required this.token});

  @override
  State<EstabelecimentoCreationPage> createState() =>
      _EstabelecimentoCreationPageState();
}

class _EstabelecimentoCreationPageState
    extends State<EstabelecimentoCreationPage> {
  final cnpjController = TextEditingController();
  final nameController = TextEditingController();
  final bairroController = TextEditingController();
  final ruaController = TextEditingController();
  final cepController = TextEditingController();
  final numeroController = TextEditingController();

  Future<void> registerEventJson(String cnpj, String name, String bairro,
      String rua, String cep, String numero, BuildContext context) async {
    var url = Uri.parse("http://10.0.2.2:8080/estabelecimentos");
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "cnpj": cnpj,
          "addressBairro": bairro,
          "addressRua": rua,
          "addressCep": cep,
          "addressNumero": numero,
        }));
    if (response.statusCode == 201) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Sucesso!',
            content: "Registro de estabelecimento realizado com sucesso!",
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(token: widget.token)));
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

  void registerEvent() {
    registerEventJson(
        cnpjController.text,
        nameController.text,
        bairroController.text,
        ruaController.text,
        cepController.text,
        numeroController.text,
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        elevation: 0.1,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  hintText: 'Digite o nome do estabelecimento',
                  obscuredText: false,
                  controller: nameController,
                ),
                MyTextField(
                  hintText: 'Digite o cnpj da empresa',
                  obscuredText: false,
                  controller: cnpjController,
                ),
                MyTextField(
                  hintText: 'Digite a rua',
                  obscuredText: false,
                  controller: ruaController,
                ),
                MyTextField(
                  hintText: 'Digite o bairro',
                  obscuredText: false,
                  controller: bairroController,
                ),
                MyTextField(
                  hintText: 'Digite o CEP',
                  obscuredText: false,
                  controller: cepController,
                ),
                MyTextField(
                  hintText: 'Digite o numero da casa',
                  obscuredText: false,
                  controller: numeroController,
                ),
                MyButton(buttonText: 'Register', buttonFunction: registerEvent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
