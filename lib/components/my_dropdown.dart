import 'package:flutter/material.dart';

class SelectionBox extends StatefulWidget {
  const SelectionBox({super.key});

  @override
  State<SelectionBox> createState() => _SelectionBoxExampleState();
}

class _SelectionBoxExampleState extends State<SelectionBox> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Função'),
      ),
      body: Center(
        child: DropdownButton<String>(
          hint: const Text("Selecione uma função"),
          value: selectedRole,
          onChanged: (String? newValue) {
            setState(() {
              selectedRole = newValue;
            });
          },
          items: <String>['Festeiro', 'Organizador', 'Vendedor']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
