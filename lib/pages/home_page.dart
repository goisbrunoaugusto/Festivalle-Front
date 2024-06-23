import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_eventos/components/my_event_tile.dart';
import 'package:projeto_eventos/model/sport_event_model.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/components/my_navigation_bar.dart';
import 'package:projeto_eventos/pages/event_page.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<dynamic> sportEventList = [];

  Future<SportEventModel?> fetchSportEvents() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/sport_events"),
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
        });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      setState(() {
        sportEventList = responseJson;
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
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: const Center(
              child: Text(
            'Eventos',
            style: TextStyle(color: Colors.white),
          )),
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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: sportEventList.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: MyEventTile(
                  title: sportEventList[index]['name'],
                  description: sportEventList[index]['description'],
                ),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(
                                token: widget.token,
                                eventID: sportEventList[index]['id'],
                                name: sportEventList[index]['name'],
                                description: sportEventList[index]
                                    ['description'],
                                ticketPrice: sportEventList[index]
                                    ['ticketPrice'],
                                eventDate: sportEventList[index]['eventDate'] ??
                                    "Data nao definida",
                                createdOn: sportEventList[index]['createdOn'],
                                location: sportEventList[index]['location'] ??
                                    "Localizacao nao definida",
                              )))
                },
              );
            },
          ),
        ),
        bottomNavigationBar: MyNavigationBar(token: widget.token));
  }
}
