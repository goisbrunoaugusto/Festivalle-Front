import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_eventos/components/my_estabelecimento_tile.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/components/my_navigation_bar.dart';
import 'package:projeto_eventos/pages/estabelecimento_create_page.dart';

class TodosEstabelecimentosPage extends StatefulWidget {
  final String token;
  const TodosEstabelecimentosPage({super.key, required this.token});

  @override
  State<TodosEstabelecimentosPage> createState() {
    return _TodosEstabelecimentosPageState();
  }
}

class _TodosEstabelecimentosPageState extends State<TodosEstabelecimentosPage> {
  List<dynamic> estabelecimentos = [];

  Future<void> fetchSportEvents() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/estabelecimentos"),
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
        });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      setState(() {
        estabelecimentos = responseJson;
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
        endDrawer: Drawer(
          backgroundColor: const Color.fromRGBO(58, 66, 86, .9),
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
                              EstabelecimentoCreationPage(token: widget.token),
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
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: const Center(
              child: Text(
            'Estabelecimentos',
            style: TextStyle(color: Colors.white),
          )),
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
            itemCount: estabelecimentos.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              return MyEstabelecimentoTile(
                name: estabelecimentos[index]['name'],
                cnpj: estabelecimentos[index]['cnpj'],
                addressBairro: estabelecimentos[index]['addressBairro'],
                addressRua: estabelecimentos[index]['addressRua'],
                addressCep: estabelecimentos[index]['addressCep'],
                addressNumero: estabelecimentos[index]['addressNumero'],
              );
            },
          ),
        ),
        bottomNavigationBar: MyNavigationBar(token: widget.token));
  }
}
