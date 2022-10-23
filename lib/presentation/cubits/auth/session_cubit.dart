
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_wallet_frontend/data/repositories/account_repository.dart';
import 'package:password_wallet_frontend/domain/models/master_password.dart';
import 'package:password_wallet_frontend/presentation/cubits/password/password_cubit.dart';

import '../../../domain/models/login.dart';
import '../../../domain/models/register.dart';
import '../../../domain/models/session.dart';
import '../../../main.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AccountRepository accountRepository;
  final FlutterSecureStorage storage;

  SessionCubit({required this.accountRepository, this.storage = const FlutterSecureStorage()}) : super(SessionUnauthenticated());

  Future<void> register({required String login, required String password, required bool isPasswordKeptAsHash}) async {
    await storage.write(key: 'STORAGE_LOGIN', value: login);
    await storage.write(key: 'STORAGE_PASSWORD', value: password);
    
    try {
      Register registerDto = Register(login: login, password: password, isPasswordKeptAsHash: isPasswordKeptAsHash);
      Session session = await accountRepository.register(registerDto);
      
      emit(SessionAuthenticated(session: session));
      
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> logIn({required String login, required String password}) async {
    await storage.write(key: 'STORAGE_LOGIN', value: login);
    await storage.write(key: 'STORAGE_PASSWORD', value: password);
    

    try {
      Login loginDto = Login(login: login, password: password);
      Session session = await accountRepository.logIn(loginDto);

      emit(SessionAuthenticated(session: session));
    
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> logInFromStorage() async {
    final login = await storage.read(key: 'STORAGE_LOGIN');
    final password = await storage.read(key: 'STORAGE_PASSWORD');

    if (login != null && password != null) {
      final storageLoginDto = Login(
        login: login,
        password: password
      );

      try {
        final session = await accountRepository.logIn(storageLoginDto);
        
        emit(SessionAuthenticated(
          session: session,
        )); 
        
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
      } on Exception {
        emit(SessionUnauthenticated());
      }
    }
  }

  Future<void> changeMasterPassword({required String token, required String oldPassword, required String newPassword, required bool isPasswordKeptAsHash}) async {
    try {
      MasterPassword masterPassword = MasterPassword(oldPassword: oldPassword, newPassword: newPassword, isPasswordKeptAsHash: isPasswordKeptAsHash);
      final session = await accountRepository.changeMasterPassword(token, masterPassword);
      
      emit(SessionAuthenticated(session: session));

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
    } on Exception {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> logOut() async {
    await storage.deleteAll();

    emit(SessionUnauthenticated());

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
  }
}