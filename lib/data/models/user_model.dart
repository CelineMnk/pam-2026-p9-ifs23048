class UserModel {
  final String username;
  final String name;
  final String role;

  UserModel({
    required this.username,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json['username'],
    name: json['name'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'name': name,
    'role': role,
  };
}