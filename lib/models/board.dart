class Board {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final int pinCount;
  final int followers;
  final bool isSecret;
  final String createdBy;
  final List<String> pins;

  Board({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.pinCount,
    required this.followers,
    required this.isSecret,
    required this.createdBy,
    required this.pins,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      pinCount: json['pinCount'] ?? 0,
      followers: json['followers'] ?? 0,
      isSecret: json['isSecret'] ?? false,
      createdBy: json['createdBy'] ?? '',
      pins: List<String>.from(json['pins'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'pinCount': pinCount,
      'followers': followers,
      'isSecret': isSecret,
      'createdBy': createdBy,
      'pins': pins,
    };
  }
}
