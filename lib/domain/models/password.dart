import 'dart:convert';

import 'package:password_wallet_frontend/domain/models/shared_password.dart';

class Password {
  String? id;
  String? password;
  String webAddress;
  String description;
  String login;
  String? accoundId;
  List<SharedPassword>? sharedTo;
  
  Password({
    this.id,
    this.password,
    required this.webAddress,
    required this.description,
    required this.login,
    this.accoundId,
    this.sharedTo,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'webAddress': webAddress,
      'description': description,
      'login': login,
      'accoundId': accoundId,
      'sharedTo': sharedTo?.map((x) => x.toMap()).toList(),
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
      sharedTo: map['sharedTo'] != null ? List<SharedPassword>.from(map['sharedTo']?.map((x) => SharedPassword.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(Map<String, dynamic> source) => Password.fromMap(source);

  // factory Password.fromJson(String source) => Password.fromMap(json.decode(source));
}
