import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:password_wallet_frontend/data/repositories/password_repository.dart';

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

      emit(PasswordSuccess(passwords));
    } on Exception {
      emit(const PasswordFailure());
    }
  }

  Future<void> addPassword(String token, Password password) async {
    try {
      emit(const PasswordLoading());
      await passwordRepository.addPassword(token, password);

      final passwords = await passwordRepository.getAllPasswords(token);
      emit(PasswordSuccess(passwords));

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
      emit(PasswordSuccess(passwords));

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
}