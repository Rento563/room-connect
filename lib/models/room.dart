class Room {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final List<String> images;
  final String roomType;
  final String ownerId;
  final List<String> amenities;

  Room({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.images,
    required this.roomType,
    required this.ownerId,
    this.amenities = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'images': images,
      'roomType': roomType,
      'ownerId': ownerId,
      'amenities': amenities,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      location: json['location'],
      images: List<String>.from(json['images']),
      roomType: json['roomType'],
      ownerId: json['ownerId'],
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }
}
