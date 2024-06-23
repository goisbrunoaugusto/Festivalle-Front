import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key, required this.buttonText, required this.buttonFunction});

  final dynamic buttonFunction;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            minimumSize: const MaterialStatePropertyAll(Size(300, 40))),
        onPressed: () {
          buttonFunction();
        },
        child: Text(
          style: const TextStyle(color: Colors.white),
          buttonText,
        ));
  }
}
