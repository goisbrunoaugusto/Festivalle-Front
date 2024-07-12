// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/components/my_multiline_text_field.dart';
import 'package:projeto_eventos/components/my_textfield.dart';
import 'package:http/http.dart' as http;

class AvaliacaoDialog extends StatelessWidget {
  final String token;
  final int eventID;
  final avaliacaoController = TextEditingController();
  final comentarioController = TextEditingController();
  final BuildContext context;

  AvaliacaoDialog(
      {super.key,
      required this.token,
      required this.eventID,
      required this.context});

  Future<void> createNews(
      int eventoId, int avaliacao, String text, BuildContext context) async {
    var url = Uri.parse("http://10.0.2.2:8080/avaliacoes");
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "eventoId": eventoId,
          "rating": avaliacao,
          "comment": text,
        }));
    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Sucesso!',
            content: "Avaliação enviada!",
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Ops!',
            content: "Não é possível avaliar sem possuir ingresso!",
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

  void registerNew() {
    createNews(eventID, int.parse(avaliacaoController.text),
        comentarioController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(children: <Widget>[
        AlertDialog(
          title: const Text('Avaliação do evento'),
          content: Column(
            children: [
              MyTextField(
                  hintText: "Digite de 0 a 10",
                  obscuredText: false,
                  controller: avaliacaoController),
              const SizedBox(
                height: 30,
              ),
              MyMultilineTextField(
                  hintText: "Deixe um comentario",
                  controller: comentarioController),
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text("Cancelar")),
            TextButton(onPressed: registerNew, child: const Text("Avaliar"))
          ],
        ),
      ]),
    );
  }
}
