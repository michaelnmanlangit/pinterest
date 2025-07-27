class Pin {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final int saves;
  final int comments;
  final List<String> tags;
  final String category;
  final DateTime createdAt;

  Pin({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.saves,
    required this.comments,
    required this.tags,
    required this.category,
    required this.createdAt,
  });

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      authorName: json['authorName'] ?? '',
      authorAvatar: json['authorAvatar'] ?? '',
      likes: json['likes'] ?? 0,
      saves: json['saves'] ?? 0,
      comments: json['comments'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'likes': likes,
      'saves': saves,
      'comments': comments,
      'tags': tags,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
