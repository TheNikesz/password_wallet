import 'dart:convert';

class IpLock {
  String accountId;
  String ipAddress;
  
  IpLock({
    required this.accountId,
    required this.ipAddress,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'ipAddress': ipAddress,
    };
  }

  factory IpLock.fromMap(Map<String, dynamic> map) {
    return IpLock(
      accountId: map['accountId'] ?? '',
      ipAddress: map['ipAddress'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IpLock.fromJson(Map<String, dynamic> source) => IpLock.fromMap(source);
}
