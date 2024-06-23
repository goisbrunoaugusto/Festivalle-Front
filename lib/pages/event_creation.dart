import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_eventos/components/my_alert_dialog.dart';
import 'package:projeto_eventos/components/my_button.dart';
import 'package:projeto_eventos/components/my_date_field.dart';
import 'package:projeto_eventos/components/my_multiline_text_field.dart';
import 'package:projeto_eventos/components/my_textfield.dart';
import 'package:projeto_eventos/model/sport_event_model.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/pages/home_page.dart';

class EventCreation extends StatefulWidget {
  final String token;

  EventCreation({super.key, required this.token});

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  final nameController = TextEditingController();
  final eventDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final ticketQuantityController = TextEditingController();
  final ticketPriceController = TextEditingController();
  final sportController = TextEditingController();

  Future<SportEventModel?> registerEventJson(
      String name,
      String eventDate,
      double ticketQuantity,
      double ticketPrice,
      String description,
      int sportId,
      BuildContext context) async {
    var url = Uri.parse("http://10.0.2.2:8080/sport_events");
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "eventDate": eventDate,
          "description": description,
          "ticketQuantity": ticketQuantity,
          "ticketPrice": ticketPrice,
          "sport_id": sportId
        }));
    if (response.statusCode == 201) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Sucesso!',
            content: "Registro de evento realizado com sucesso!",
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
    double doubleTicketPrice = double.parse(ticketPriceController.text);
    double doubleTicketQuantity = double.parse(ticketQuantityController.text);
    int intsportId = int.parse(sportController.text);
    print(
        '------------------------------------------- ${eventDateController.text}');
    registerEventJson(
        nameController.text,
        eventDateController.text,
        doubleTicketQuantity,
        doubleTicketPrice,
        descriptionController.text,
        intsportId,
        context);
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
                  hintText: 'Digite o nome do evento',
                  obscuredText: false,
                  controller: nameController,
                ),
                MyDateField(
                  hintText: 'Digite a data do evento',
                  controller: eventDateController,
                ),
                MyTextField(
                  hintText: 'Digite a quantidade de ingressos disponiveis',
                  obscuredText: false,
                  controller: ticketQuantityController,
                ),
                MyTextField(
                  hintText: 'Digite o preco do ingresso',
                  obscuredText: false,
                  controller: ticketPriceController,
                ),
                MyTextField(
                  hintText: 'Digite o id do esporte',
                  obscuredText: false,
                  controller: sportController,
                ),
                MyMultilineTextField(
                  hintText: 'Digite a descricao do evento',
                  controller: descriptionController,
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
