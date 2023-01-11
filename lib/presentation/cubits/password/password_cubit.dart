import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:password_wallet_frontend/data/repositories/password_repository.dart';
import 'package:password_wallet_frontend/domain/models/shared_password.dart';

import '../../../domain/models/password.dart';
import '../../../main.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final PasswordRepository passwordRepository;

  PasswordCubit({required this.passwordRepository}) : super(const PasswordInitial());

  Future<void> clearPasswordsInSession() async {
    emit(const PasswordInitial());
  }

  Future<void> getAllPasswords(String token) async {
    try {
      emit(const PasswordLoading());
      final passwords = await passwordRepository.getAllPasswords(token);
      final sharedPasswords = await passwordRepository.getAllSharedPasswords(token);

      emit(PasswordSuccess(passwords: passwords, sharedPasswords: sharedPasswords));
    } on Exception {
      emit(const PasswordFailure());
    }
  }



  Future<void> addPassword(String token, Password password) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.addPassword(token, password);

      final passwords = await passwordRepository.getAllPasswords(token);
      final sharedPasswords = await passwordRepository.getAllSharedPasswords(token);

      emit(PasswordSuccess(passwords: passwords, sharedPasswords: sharedPasswords));

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<void> addSharedPassword(String token, SharedPassword sharedPassword) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.addSharedPassword(token, sharedPassword);

      final passwords = await passwordRepository.getAllPasswords(token);
      final sharedPasswords = await passwordRepository.getAllSharedPasswords(token);

      emit(PasswordSuccess(passwords: passwords, sharedPasswords: sharedPasswords));

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<void> editPassword(String token, Password password) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.editPassword(token, password);

      final passwords = await passwordRepository.getAllPasswords(token);
      final sharedPasswords = await passwordRepository.getAllSharedPasswords(token);

      emit(PasswordSuccess(passwords: passwords, sharedPasswords: sharedPasswords));

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<void> deletePassword(String token, String id) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.deletePassword(token, id);
      await getAllPasswords(token);
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<void> deleteSharedPassword(String token, String id, Password password) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.deleteSharedPassword(token, id);
      await getAllPasswords(token);

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<String> decryptPassword(String token, String id) async {
    try {
      emit(const PasswordLoading());
      final decryptedPassword = await passwordRepository.decryptPassword(token, id);
      await getAllPasswords(token);
      return decryptedPassword; 
    } on Exception {
      emit(const PasswordFailure());
      throw NullThrownError;
    }
  }

  void changeModeSwitchValue(bool value) {
    if (state is PasswordSuccess) {
      emit((state as PasswordSuccess).copyWith(
        isEdit: value,
      ));
    }
  }
}