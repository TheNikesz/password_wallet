import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_wallet_frontend/presentation/widgets/session_status.dart';

import '../../../main.dart';
import '../../cubits/auth/session_cubit.dart';
import '../../cubits/password/password_cubit.dart';

class PasswordsPage extends StatelessWidget {
  const PasswordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
      return BlocBuilder<PasswordCubit, PasswordState>(
        builder: (context, passwordState) {
          final passwordCubit = BlocProvider.of<PasswordCubit>(context);
          if (sessionState is SessionAuthenticated &&
              passwordState is PasswordInitial) {
            passwordCubit.getAllPasswords(sessionState.session.token);
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SessionStatus(),
                  _buildLoginStatistics(context, sessionState),
                  if (passwordState is PasswordSuccess)
                    _buildModeSwitch(context, passwordState.isEdit),
                  _buildAddPasswordButton(context),
                  _buildPasswords(sessionState, ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildPassword(sessionState, int index) {
    return BlocBuilder<PasswordCubit, PasswordState>(
        builder: (context, passwordState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (passwordState is PasswordSuccess) ...[
              Text(passwordState.passwords.elementAt(index).login),
              Text(passwordState.passwords.elementAt(index).webAddress),
              Text(passwordState.passwords.elementAt(index).description),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDecryptPasswordButton(
                      context, sessionState, passwordState, index),
                  _buildSharePasswordButton(
                    context, sessionState, passwordState, index),
                  _buildEditPasswordButton(
                      context, sessionState, passwordState, index, passwordState.isEdit),
                  _buildDeletePasswordButton(
                      context, sessionState, passwordState, index, passwordState.isEdit),
                ],
              ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildSharedPassword(sessionState, int index) {
    return BlocBuilder<PasswordCubit, PasswordState>(
        builder: (context, passwordState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (passwordState is PasswordSuccess) ...[
              Text(passwordState.sharedPasswords.elementAt(index).login),
              Text(passwordState.sharedPasswords.elementAt(index).webAddress),
              Text(passwordState.sharedPasswords.elementAt(index).description),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDecryptPasswordButton(
                      context, sessionState, passwordState, index),
                ],
              ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildDecryptPasswordButton(BuildContext context,
      SessionState sessionState, PasswordState passwordState, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (passwordState is PasswordSuccess &&
              sessionState is SessionAuthenticated) {
            final passwordCubit = BlocProvider.of<PasswordCubit>(context);
            final decryptedPassword = await passwordCubit.decryptPassword(
                sessionState.session.token,
                passwordState.passwords.elementAt(index).id!);
            Fluttertoast.showToast(
                msg: decryptedPassword,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                webPosition: 'center',
                webShowClose: true,
                timeInSecForIosWeb: 3,
                webBgColor: '#2196F3',
                backgroundColor: Colors.blue,
                fontSize: 16.0);
          }
        },
        child: const Text('Decrypt password'),
      ),
    );
  }

  Widget _buildDeletePasswordButton(BuildContext context,
      SessionState sessionState, PasswordState passwordState, int index, bool isEdit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: isEdit ? () async {
          if (passwordState is PasswordSuccess &&
              sessionState is SessionAuthenticated) {
            final passwordCubit = BlocProvider.of<PasswordCubit>(context);
            await passwordCubit.deletePassword(sessionState.session.token,
                passwordState.passwords.elementAt(index).id!);
          }
        } : null,
        child: const Text('Delete password'),
      ),
    );
  }

  Widget _buildPasswords(SessionState sessionState) {
    return BlocBuilder<PasswordCubit, PasswordState>(
      builder: (context, passwordState) {
        List<Widget> passwordWidgets = [];
        if (passwordState is PasswordSuccess) {
          for (var i = 0; i < passwordState.passwords.length; i++) {
            passwordWidgets.add(
              const Divider(
                color: Colors.black,
              ),
            );
            passwordWidgets.add(
              _buildPassword(sessionState, i),
            );
          }

          for (var i = 0; i < passwordState.sharedPasswords.length; i++) {
            passwordWidgets.add(
              const Divider(
                color: Colors.black,
              ),
            );
            passwordWidgets.add(
              _buildSharedPassword(sessionState, i),
            );
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: passwordWidgets,
        );
      },
    );
  }

  Widget _buildAddPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          navigatorKey.currentState?.pushNamed('/add-password');
        },
        child: const Text('Add new password'),
      ),
    );
  }

  Widget _buildEditPasswordButton(BuildContext context, SessionState sessionState, PasswordState passwordState, int index, bool isEdit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: isEdit ? () {
          if (passwordState is PasswordSuccess && sessionState is SessionAuthenticated) {
            navigatorKey.currentState?.pushNamed('/edit-password', arguments: passwordState.passwords.elementAt(index));
          }
        } : null,
          
        child: const Text('Edit password'),
      ),
    );
  }

  Widget _buildSharePasswordButton(BuildContext context, SessionState sessionState, PasswordState passwordState, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (passwordState is PasswordSuccess && sessionState is SessionAuthenticated) {
            navigatorKey.currentState?.pushNamed('/share-password', arguments: passwordState.passwords.elementAt(index));
          }
        },
          
        child: const Text('Share password'),
      ),
    );
  }

  Widget _buildLoginStatistics(BuildContext context, SessionState state) {
    final sessionCubit = BlocProvider.of<SessionCubit>(context);
    if (state is SessionAuthenticated) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: sessionCubit.getLoginStatistics(token: state.session.token),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else {
                return const Text('');
              }
            }),
      );
    } else {
      return const Text('');
    }
  }

  Widget _buildModeSwitch(BuildContext context, bool isEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Read mode"),
        Switch(
          value: isEdit,
          onChanged: (value) {
            final passwordCubit = BlocProvider.of<PasswordCubit>(context);
            passwordCubit.changeModeSwitchValue(value);
          },
        ),
        const Text("Edit mode"),
      ],
    );
  }
}
