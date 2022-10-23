import 'dart:convert';

class Register {
  String login;
  String password;
  bool isPasswordKeptAsHash;
  
  Register({
    required this.login,
    required this.password,
    required this.isPasswordKeptAsHash,
  });


  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'password': password,
      'isPasswordKeptAsHash': isPasswordKeptAsHash,
    };
  }

  factory Register.fromMap(Map<String, dynamic> map) {
    return Register(
      login: map['login'] ?? '',
      password: map['password'] ?? '', 
      isPasswordKeptAsHash: map['isPasswordKeptAsHash'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Register.fromJson(String source) => Register.fromMap(json.decode(source));
}
