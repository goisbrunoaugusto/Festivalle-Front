import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeto_eventos/model/reward_model.dart';
import 'package:projeto_eventos/pages/reward_update_page.dart';

class RewardsListPage extends StatefulWidget {
  final String token;

  const RewardsListPage({super.key, required this.token});

  @override
  State<RewardsListPage> createState() => _RewardsListPageState();
}

class _RewardsListPageState extends State<RewardsListPage> {
  late Future<List<RewardModel>> rewards;

  @override
  void initState() {
    super.initState();
    rewards = fetchRewards();
  }

  Future<List<RewardModel>> fetchRewards() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/rewards/all'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => RewardModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load rewards');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards List'),
      ),
      body: FutureBuilder<List<RewardModel>>(
        future: rewards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No rewards available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reward = snapshot.data![index];
                return GestureDetector(
                  child: ListTile(
                    title: Text(reward.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descricao:  ${reward.description}'),
                        Text('Evento:  ${reward.sportEvents}'),
                      ],
                    ),
                    trailing: Text('\$${reward.price}'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RewardUpdatePage(
                          token: widget.token,
                          rewardId: reward.id,
                          name: reward.name,
                          description: reward.description,
                          price: reward.price,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
