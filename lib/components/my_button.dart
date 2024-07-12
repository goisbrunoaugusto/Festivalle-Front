import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key, required this.buttonText, required this.buttonFunction});

  final dynamic buttonFunction;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          buttonFunction();
        },
        child: Text(
          buttonText,
        ));
  }
}
