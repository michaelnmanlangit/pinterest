class User {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String avatar;
  final int followers;
  final int following;
  final int pins;
  final bool verified;
  final String website;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.avatar,
    required this.followers,
    required this.following,
    required this.pins,
    required this.verified,
    required this.website,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      avatar: json['avatar'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      pins: json['pins'] ?? 0,
      verified: json['verified'] ?? false,
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'avatar': avatar,
      'followers': followers,
      'following': following,
      'pins': pins,
      'verified': verified,
      'website': website,
    };
  }
}
