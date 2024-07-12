import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_eventos/components/my_event_tile.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/components/my_navigation_bar.dart';
import 'package:projeto_eventos/pages/estabelecimento_create_page.dart';
import 'package:projeto_eventos/pages/event_page.dart';
import 'package:projeto_eventos/pages/todos_estabelecimentos_page.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<dynamic> events = [];

  Future<void> fetchSportEvents() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/eventos"),
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
        });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      setState(() {
        events = responseJson;
      });
    } else {
      throw Exception('Error fetching events');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSportEvents();
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
                          "Criar Estabelecimento",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EstabelecimentoCreationPage(token: widget.token),
                        ),
                      );
                    },
                  ),
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
                        Flexible(
                          child: Text(
                            "Todos os estabelecimentos",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TodosEstabelecimentosPage(token: widget.token),
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
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Eventos',
            style: TextStyle(color: Colors.white),
          ),
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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: events.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: MyEventTile(
                  title: events[index]['title'],
                  description: events[index]['description'],
                ),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(
                                token: widget.token,
                                eventID: events[index]['id'],
                                title: events[index]['title'],
                                description: events[index]['description'],
                                ingressoPrice: events[index]['ingressoPrice'],
                                startDateTime: events[index]['startDateTime'],
                                endDateTime: events[index]['endDateTime'],
                                qtyIngressos: events[index]['qtyIngressos'],
                              )))
                },
              );
            },
          ),
        ),
        bottomNavigationBar: MyNavigationBar(token: widget.token));
  }
}
