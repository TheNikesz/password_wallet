import 'dart:convert';

class Login {
  String login;
  String password;
  
  Login({
    required this.login,
    required this.password,
  });


  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'password': password,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      login: map['login'] ?? '',
      password: map['password'] ?? '', 
    );
  }

  String toJson() => json.encode(toMap());

  // factory Login.fromJson(Map<String, dynamic> source) => Login.fromMap(source);

  factory Login.fromJson(String source) => Login.fromMap(json.decode(source));
}
