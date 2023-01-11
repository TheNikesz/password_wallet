import 'package:password_wallet_frontend/data/data_sources/api.dart';

import '../../domain/models/password.dart';
import '../../domain/models/shared_password.dart';

class PasswordRepository {
  final PasswordApi _passwordApi;
  final SharedPasswordApi _sharedPasswordApi;

  PasswordRepository({
    PasswordApi? passwordApi,
    SharedPasswordApi? sharedPasswordApi,
  }) : _passwordApi = passwordApi ?? PasswordApi(), _sharedPasswordApi = sharedPasswordApi ?? SharedPasswordApi();

  Future<List<Password>> getAllPasswords(String token) async {
    try {
      return await _passwordApi.getAllPasswords(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Password>> getAllSharedPasswords(String token) async {
    try {
      return await _sharedPasswordApi.getAllSharedPasswords(token);
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

  Future<SharedPassword> addSharedPassword(String token, SharedPassword sharedPassword) async {
    try {
      return await _sharedPasswordApi.addSharedPassword(token, sharedPassword);
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

  Future<void> deleteSharedPassword(String token, String id) async {
    try {
      return await _sharedPasswordApi.deleteSharedPassword(token, id);
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

  Future<String> decryptSharedPassword(String token, String id) async {
    try {
      return await _sharedPasswordApi.decryptSharedPassword(token, id);
    } catch (e) {
      rethrow;
    }
  }
}