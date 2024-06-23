// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import "package:jwt_decoder/jwt_decoder.dart";
import "package:projeto_eventos/components/my_alert_dialog.dart";
import "package:projeto_eventos/components/my_navigation_bar.dart";
import "package:projeto_eventos/components/my_button.dart";
import "package:http/http.dart" as http;
import "package:projeto_eventos/pages/attraction_create_page.dart";
import "package:projeto_eventos/pages/reward_creation_page.dart";
import "package:projeto_eventos/pages/reward_list_page.dart";

class EventPage extends StatefulWidget {
  final String token;
  final String name;
  final String description;
  final double ticketPrice;
  final String createdOn;
  final String eventDate;
  final String location;
  final int eventID;

  const EventPage(
      {super.key,
      required this.token,
      required this.name,
      required this.description,
      required this.ticketPrice,
      required this.createdOn,
      required this.eventDate,
      required this.location,
      required this.eventID});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<void> buyTicket() async {
    var url =
        Uri.parse("http://10.0.2.2:8080/tickets/purchase/${widget.eventID}");
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
    if (response.statusCode == 500) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Ops!',
              content: "Usuário já tem o ingresso!",
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

  Future<void> confirmAttendance() async {
    Map<String, dynamic> decodedToken;
    int userID;

    decodedToken = getID();
    userID = decodedToken['userId'];
    var url = Uri.parse(
        "http://10.0.2.2:8080/tickets/confirmAttendance/${widget.eventID}/$userID");
    var response = await http.post(
      url,
      headers: <String, String>{"Authorization": "Bearer ${widget.token}"},
    );
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Sucesso!',
              content: "Presença confirmada com sucesso!",
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
    if (response.statusCode == 400) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Ops!',
              content: "Usuário já confirmado!",
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
    if (response.statusCode == 500) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
              title: 'Ops!',
              content: "Usuário ainda não comprou o ticket!",
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

  getID() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    return decodedToken;
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
                        "Adicionar Recompensa",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RewardCreationPage(
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
                        "Listar Recompensa",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RewardsListPage(token: widget.token),
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
                      Text(
                        "Adicionar Atração",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttractionCreationPage(
                            token: widget.token, eventID: widget.eventID),
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
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
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
                widget.name,
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
                  widget.eventDate,
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
                  Icons.location_on,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.location,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 150,
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
            Row(
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
            const SizedBox(
              height: 30,
            ),
            MyButton(buttonText: 'Comprar Ingresso', buttonFunction: buyTicket),
            const SizedBox(
              height: 15,
            ),
            MyButton(
                buttonText: 'Confirmar Presença',
                buttonFunction: confirmAttendance)
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(token: widget.token),
    );
  }
}
