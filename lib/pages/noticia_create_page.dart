import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/components/my_date_field.dart';
import 'package:projeto_eventos/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/pages/home_page.dart';

class NoticiaCreationPage extends StatefulWidget {
  final String token;

  final int eventID;

  const NoticiaCreationPage(
      {super.key, required this.token, required this.eventID});

  @override
  State<NoticiaCreationPage> createState() => _NoticiaCreationPageState();
}

class _NoticiaCreationPageState extends State<NoticiaCreationPage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final dateController = TextEditingController();

  Future<void> registerEventJson(String title, String text, String data, int id,
      BuildContext context) async {
    var url =
        Uri.parse("http://10.0.2.2:8080/noticias?eventoId=${widget.eventID}");
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "title": title,
          "date": data,
          "text": text,
          "midiaPath": "string",
          "eventoId": id,
        }));
    if (response.statusCode == 201) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Sucesso!',
            content: "Noticia de estabelecimento realizado com sucesso!",
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
            content: "Somente organizadores podem registrar noticias.",
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
    registerEventJson(titleController.text, textController.text,
        dateController.text, widget.eventID, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
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
                  hintText: 'Digite o titulo da noticia',
                  obscuredText: false,
                  controller: titleController,
                ),
                MyDateField(
                  hintText: 'Digite a data de começo do evento',
                  controller: dateController,
                ),
                MyTextField(
                  hintText: 'Digite a noticia',
                  obscuredText: false,
                  controller: textController,
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
