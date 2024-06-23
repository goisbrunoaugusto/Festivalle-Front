class RewardModel {
  final String name;
  final String description;
  final int price;
  final String sportEvents;
  final int id;

  RewardModel(
      {required this.name,
      required this.description,
      required this.price,
      required this.sportEvents,
      required this.id});

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      sportEvents: json['sportEvents'][0]['name'],
    );
  }
}
