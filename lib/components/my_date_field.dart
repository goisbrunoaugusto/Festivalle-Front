import 'package:flutter/material.dart';

class MyDateField extends StatefulWidget {
  final String hintText;
  final controller;

  const MyDateField({super.key, required this.hintText, this.controller});

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(20100));
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        readOnly: true,
        onTap: () => {_selectDate()},
      ),
    );
  }
}
