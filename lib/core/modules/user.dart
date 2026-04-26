class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      age: json["age"],
      isVerified: json["isVerified"],
    );
  }
}