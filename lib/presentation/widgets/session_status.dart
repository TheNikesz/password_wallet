import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../cubits/auth/session_cubit.dart';
import '../cubits/password/password_cubit.dart';

class SessionStatus extends StatelessWidget {
  const SessionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is SessionAuthenticated) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state.session.login),
              ),
              _buildLogOutButton(context),
              _buildChangeMasterPasswordButton(context),
            ],
          ],
        );
      },
    );
  }
  
  Widget _buildLogOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          final sessionCubit = BlocProvider.of<SessionCubit>(context);
          await sessionCubit.logOut();
          final passwordCubit = BlocProvider.of<PasswordCubit>(context);
          await passwordCubit.clearPasswordsInSession();
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
        },
        child: const Text('Log out'),
      ),
    );
  }

  Widget _buildChangeMasterPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          navigatorKey.currentState?.pushNamed('/change-master-password');
        },
        child: const Text('Change master password'),
      ),
    );
  }
}