import "package:flutter/material.dart";
import "package:projeto_eventos/pages/event_creation.dart";
import "package:projeto_eventos/pages/home_page.dart";

class MyNavigationBar extends StatelessWidget {
  final String token;
  const MyNavigationBar({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      child: BottomAppBar(
        color: const Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(token: token)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_box, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventCreation(token: token)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
