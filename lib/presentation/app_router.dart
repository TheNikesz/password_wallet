import 'package:flutter/material.dart';
import 'package:password_wallet_frontend/presentation/pages/auth/auth_page.dart';
import 'package:password_wallet_frontend/presentation/pages/lock/ip_locks_page.dart';
import 'package:password_wallet_frontend/presentation/pages/password/add_password_page.dart';
import 'package:password_wallet_frontend/presentation/pages/password/share_password_page.dart';
import 'package:password_wallet_frontend/presentation/pages/password/change_master_password_page.dart';
import 'package:password_wallet_frontend/presentation/pages/password/edit_password_page.dart';
import 'package:password_wallet_frontend/presentation/pages/password/passwords_page.dart';

import '../domain/models/password.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        switch (settings.name) {
          case '/auth':
            return AuthPage();
          case '/add-password':
            return AddPasswordPage();
          case '/edit-password':
            final password = settings.arguments as Password;
            return EditPasswordPage(password: password,);
          case '/share-password':
            final password = settings.arguments as Password;
            return SharePasswordPage(password: password,);
          case '/change-master-password':
            return ChangeMasterPasswordPage();
          case '/passwords':
            return const PasswordsPage();
          case '/manage-ip-locks':
            return const IpLocksPage();  
          default:
            return AuthPage();
        }
    });
  }
}