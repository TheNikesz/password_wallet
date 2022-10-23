import 'dart:convert';

class MasterPassword {
  String oldPassword;
  String newPassword;
  bool isPasswordKeptAsHash;
  
  MasterPassword({
    required this.oldPassword,
    required this.newPassword,
    required this.isPasswordKeptAsHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'isPasswordKeptAsHash': isPasswordKeptAsHash,
    };
  }

  factory MasterPassword.fromMap(Map<String, dynamic> map) {
    return MasterPassword(
      oldPassword: map['oldPassword'] ?? '',
      newPassword: map['newPassword'] ?? '',
      isPasswordKeptAsHash: map['isPasswordKeptAsHash'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MasterPassword.fromJson(String source) => MasterPassword.fromMap(json.decode(source));
}
