import 'dart:convert';

class Password {
  String? id;
  String? password;
  String webAddress;
  String description;
  String login;
  String? accoundId;
  
  Password({
    this.id,
    this.password,
    required this.webAddress,
    required this.description,
    required this.login,
    this.accoundId,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'webAddress': webAddress,
      'description': description,
      'login': login,
      'accoundId': accoundId,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'],
      password: map['password'],
      webAddress: map['webAddress'] ?? '',
      description: map['description'] ?? '',
      login: map['login'] ?? '',
      accoundId: map['accoundId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(Map<String, dynamic> source) => Password.fromMap(source);
}
