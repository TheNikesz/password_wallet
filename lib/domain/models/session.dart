import 'dart:convert';

class Session {
  String login;
  String token;

  Session({
    required this.login,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'token': token,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      login: map['login'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) => Session.fromMap(json.decode(source));
}
