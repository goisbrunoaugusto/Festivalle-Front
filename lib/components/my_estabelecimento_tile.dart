import 'package:flutter/material.dart';

class MyEstabelecimentoTile extends StatelessWidget {
  final String name;
  final String cnpj;
  final String? addressBairro;
  final String? addressRua;
  final String? addressCep;
  final String? addressNumero;

  const MyEstabelecimentoTile(
      {super.key,
      required this.name,
      required this.cnpj,
      required this.addressBairro,
      required this.addressRua,
      required this.addressCep,
      required this.addressNumero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(43, 168, 168, 168),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          children: [
            Text(
              cnpj,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Bairro ${addressBairro ?? "nao fornecido"}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Rua ${addressRua ?? "nao fornecida"}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Numero ${addressNumero ?? "nao fornecido"}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "CEP ${addressCep ?? "nao fornecido"}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
