import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:password_wallet_frontend/domain/models/login.dart';
import 'package:password_wallet_frontend/domain/models/master_password.dart';
import 'package:password_wallet_frontend/domain/models/session.dart';

import '../../domain/models/password.dart';
import '../../domain/models/register.dart';

class AccountApi {
  static const _baseUrl = 'https://localhost:7287/api/Account';

  Future<Session> logIn(Login login) async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    var response = await dio.post('$_baseUrl/login', data: login.toJson());

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    return Session.fromMap(response.data);
  }

  Future<Session> register(Register register) async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    var response = await dio.post('$_baseUrl/register', data: register.toJson());

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    return Session.fromMap(response.data);
  }

  Future<Session> changeMasterPassword(String token, MasterPassword masterPassword) async {
      Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.patch('$_baseUrl/change-password', data: masterPassword.toJson());

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    print(response.data);

    return Session.fromMap(response.data);
  }
}

class PasswordApi {
  static const _baseUrl = 'https://localhost:7287/api/Passwords';
  Dio dio = Dio();

  Future<List<Password>> getAllPasswords(String token) async {
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.get(_baseUrl);

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    final parsedJson = response.data as List;
    return parsedJson.map((data) => Password.fromJson(data)).toList();
  }

  Future<Password> addPassword(String token, Password password) async {
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.post(_baseUrl, data: password.toJson());

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    return Password.fromJson(response.data);
  }

  Future<Password> editPassword(String token, Password password) async {
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.patch(_baseUrl, data: password.toJson());

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    return Password.fromJson(response.data);
  }

  Future<void> deletePassword(String token, String id) async {
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.delete('$_baseUrl/$id');

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }
  }

  Future<String> decryptPassword(String token, String id) async {
    dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.get('$_baseUrl/decrypt/$id');

    if (response.statusCode != 200) {
      throw HttpException(response.statusMessage ?? '');
    }

    return response.data;
  }
}