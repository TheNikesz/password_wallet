import 'package:password_wallet_frontend/data/data_sources/api.dart';

import '../../domain/models/password.dart';

class PasswordRepository {
  final PasswordApi _passwordApi;

  PasswordRepository({
    PasswordApi? passwordApi,
  }) : _passwordApi = passwordApi ?? PasswordApi();

  Future<List<Password>> getAllPasswords(String token) async {
    try {
      return await _passwordApi.getAllPasswords(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<Password> addPassword(String token, Password password) async {
    try {
      return await _passwordApi.addPassword(token, password);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Password> editPassword(String token, Password password) async {
    try {
      return await _passwordApi.editPassword(token, password);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> deletePassword(String token, String id) async {
    try {
      return await _passwordApi.deletePassword(token, id);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> decryptPassword(String token, String id) async {
    try {
      return await _passwordApi.decryptPassword(token, id);
    } catch (e) {
      rethrow;
    }
  }
}