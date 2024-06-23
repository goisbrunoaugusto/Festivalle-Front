import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RewardUpdatePage extends StatefulWidget {
  const RewardUpdatePage(
      {super.key,
      required this.token,
      required this.rewardId,
      required this.name,
      required this.description,
      required this.price});

  final String description;
  final int price;
  final String name;
  final String token;
  final int rewardId;

  @override
  State<RewardUpdatePage> createState() => _RewardUpdatePageState();
}

class _RewardUpdatePageState extends State<RewardUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      List<Map<String, int>> events = [
        {
          'id': widget.rewardId,
        }
      ];
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/rewards/${widget.rewardId}'),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'sportEvents': events,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reward successfully updated!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update reward')),
        );
      }
    }
  }

  Future<void> deleteReward(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/rewards/${widget.rewardId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reward deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete reward')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Recompensa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update'),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => deleteReward,
                child: const Text('Delete'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
