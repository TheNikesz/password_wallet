import 'dart:convert';

class SharedPassword {
  String id;
  String login;
  SharedPassword({
    required this.id,
    required this.login,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'login': login,
    };
  }

  factory SharedPassword.fromMap(Map<String, dynamic> map) {
    return SharedPassword(
      id: map['id'] ?? '',
      login: map['login'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedPassword.fromJson(Map<String, dynamic> source) => SharedPassword.fromMap(source);
}
