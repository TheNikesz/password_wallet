import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_wallet_frontend/data/data_sources/api.dart';
import 'package:password_wallet_frontend/presentation/app_router.dart';
import 'package:password_wallet_frontend/presentation/cubits/auth/session_cubit.dart';
import 'package:password_wallet_frontend/presentation/cubits/password/password_cubit.dart';
import 'package:password_wallet_frontend/presentation/pages/password/change_master_password_page.dart';

import 'data/repositories/account_repository.dart';
import 'data/repositories/password_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(PasswordWalletApp(
    appRouter: AppRouter(),
  ));
}

class PasswordWalletApp extends StatelessWidget {
  final AppRouter appRouter;

  const PasswordWalletApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AccountRepository(
            accountApi: AccountApi(),
          ),
        ),
        RepositoryProvider(
          create: (context) => PasswordRepository(
            passwordApi: PasswordApi(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => SessionCubit(
          accountRepository: context.read<AccountRepository>(),
        )..logInFromStorage(),
        child: BlocProvider(
          create: (context) => PasswordCubit(
            passwordRepository: context.read<PasswordRepository>(),
          ),
          child: MaterialApp(
            title: 'Password wallet',
            onGenerateRoute: appRouter.generateRoute,
            navigatorKey: navigatorKey,
            theme: ThemeData(),
          ),
        ),
      ),
    );
  }
}
