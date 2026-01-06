class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final int totalQuizzesTaken;
  final double averageScore;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.totalQuizzesTaken,
    required this.averageScore,
    required this.joinedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        profileImage: json['profileImage'] as String?,
        totalQuizzesTaken: json['totalQuizzesTaken'] as int,
        averageScore: json['averageScore'] as double,
        joinedDate: DateTime.parse(json['joinedDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'totalQuizzesTaken': totalQuizzesTaken,
        'averageScore': averageScore,
        'joinedDate': joinedDate.toIso8601String(),
      };
}
