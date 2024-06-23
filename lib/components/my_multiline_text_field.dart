import 'package:flutter/material.dart';

class MyMultilineTextField extends StatelessWidget {
  final String hintText;
  final controller;

  const MyMultilineTextField(
      {super.key, required this.hintText, this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
