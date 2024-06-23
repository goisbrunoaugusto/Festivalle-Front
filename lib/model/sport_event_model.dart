class SportEventModel {
  final String name;
  final String description;
  final int maxTicketQuantity;
  final int ticketPrice;
  final DateTime createdOn;
  final DateTime eventDate;

  const SportEventModel(
      {required this.name,
      required this.description,
      required this.maxTicketQuantity,
      required this.ticketPrice,
      required this.createdOn,
      required this.eventDate});

  factory SportEventModel.fromJson(List<dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'description': String description,
        'ticketQuantity': int maxTicketQuantity,
        'ticketPrice': int ticketPrice,
        'createdOn': DateTime createdOn,
        'eventDate': DateTime eventDate,
      } =>
        SportEventModel(
          name: name,
          createdOn: createdOn,
          description: description,
          maxTicketQuantity: maxTicketQuantity,
          ticketPrice: ticketPrice,
          eventDate: eventDate,
        ),
      _ => throw const FormatException('Failed to load sport event list.'),
    };
  }
}
