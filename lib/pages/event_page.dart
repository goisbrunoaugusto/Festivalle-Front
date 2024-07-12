// ignore_for_file: use_build_context_synchronously

import "dart:convert";

import "package:flutter/material.dart";
import "package:projeto_eventos/components/my_alert_dialog.dart";
import "package:projeto_eventos/components/my_navigation_bar.dart";
import "package:projeto_eventos/components/my_button.dart";
import "package:http/http.dart" as http;
import "package:projeto_eventos/dialogs/avaliacao_dialog.dart";
import "package:projeto_eventos/pages/attraction_create_page.dart";
import "package:projeto_eventos/pages/noticia_create_page.dart";

class EventPage extends StatefulWidget {
  final String token;
  final String title;
  final String description;
  final double ingressoPrice;
  final String startDateTime;
  final String endDateTime;
  final int qtyIngressos;
  final int eventID;

  const EventPage(
      {super.key,
      required this.token,
      required this.title,
      required this.description,
      required this.ingressoPrice,
      required this.startDateTime,
      required this.endDateTime,
      required this.eventID,
      required this.qtyIngressos});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> news = [];

  Future<void> buyTicket() async {
    var url = Uri.parse(
        "http://10.0.2.2:8080/ingressos/comprar?eventoId=${widget.eventID}");
    var response = await http.post(
      url,
      headers: <String, String>{"Authorization": "Bearer ${widget.token}"},
    );
    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Sucesso!',
              content: "Compra realizada com sucesso!",
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
            );
          });
    }
    if (response.statusCode != 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Ops!',
              content: "Houve um erro ao comprar ingresso!",
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
            );
          });
    }
  }

  Future<void> fetchNews() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/noticias/evento/${widget.eventID}"),
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
        });
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> responseJson = json.decode(response.body);
      setState(() {
        news = responseJson;
      });
    } else if (response.statusCode == 500) {
      throw Exception('Error fetching events');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_box,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Criar Noticia",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticiaCreationPage(
                            token: widget.token, eventID: widget.eventID),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.format_list_numbered,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Avaliar",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvaliacaoDialog(
                            context: context,
                            eventID: widget.eventID,
                            token: widget.token),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        elevation: 0.1,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.list,
                color: Colors.white,
              ),
            );
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 45,
                ),
                const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "Data de inicio: ${widget.startDateTime.split(r'T')[0]}",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 45,
                ),
                const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "Data de fim: ${widget.endDateTime.split(r'T')[0]}",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 45,
                ),
                const Icon(
                  Icons.attach_money_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "Preço: ${widget.ingressoPrice}",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Noticias",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 41, 190, 140),
                      Color.fromARGB(255, 89, 170, 143),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: ListView.builder(
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 45,
                                ),
                                const Icon(
                                  Icons.newspaper_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  news[index]["title"],
                                  style: const TextStyle(
                                      fontSize: 28, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 45,
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  news[index]["text"],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Sobre o evento",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 41, 190, 140),
                    Color.fromARGB(255, 89, 170, 143),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        widget.description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(buttonText: 'Comprar Ingresso', buttonFunction: buyTicket),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(token: widget.token),
    );
  }
}
