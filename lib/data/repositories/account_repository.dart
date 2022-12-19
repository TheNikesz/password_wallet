import 'package:password_wallet_frontend/data/data_sources/api.dart';
import 'package:password_wallet_frontend/domain/models/master_password.dart';

import '../../domain/models/ip_lock.dart';
import '../../domain/models/login.dart';
import '../../domain/models/register.dart';
import '../../domain/models/session.dart';

class AccountRepository {
  final AccountApi _accountApi;

  AccountRepository({
    AccountApi? accountApi,
  }) : _accountApi = accountApi ?? AccountApi();

  Future<Session> logIn(Login login) async {
    try {
      return await _accountApi.logIn(login);
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> register(Register register) async {
    try {
      return await _accountApi.register(register);
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> changeMasterPassword(String token, MasterPassword masterPassword) async {
    try {
      return await _accountApi.changeMasterPassword(token, masterPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getLoginStatistics(String token) async {
    try {
      return await _accountApi.getLoginStatistics(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IpLock>> getAllIpLocks(String token) async {
    try {
      return await _accountApi.getAllIpLocks(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteIpLock(String token, String ipAddress) async {
    try {
      return await _accountApi.deleteIpLock(token, ipAddress);
    } catch (e) {
      rethrow;
    }
  }
}