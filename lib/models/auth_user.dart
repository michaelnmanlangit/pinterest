class AuthUser {
  final String id;
  final String email;
  final String name;
  final String username;
  final String avatar;
  final String bio;
  final int followers;
  final int following;
  final int pins;
  final bool verified;
  final String website;
  final DateTime createdAt;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.avatar,
    required this.bio,
    required this.followers,
    required this.following,
    required this.pins,
    required this.verified,
    required this.website,
    required this.createdAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      pins: json['pins'] ?? 0,
      verified: json['verified'] ?? false,
      website: json['website'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'followers': followers,
      'following': following,
      'pins': pins,
      'verified': verified,
      'website': website,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
