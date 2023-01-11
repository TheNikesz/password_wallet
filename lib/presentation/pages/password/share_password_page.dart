import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../domain/models/password.dart';
import '../../../domain/models/shared_password.dart';
import '../../cubits/auth/session_cubit.dart';
import '../../cubits/password/password_cubit.dart';

class SharePasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final Password password;

  SharePasswordPage({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  _buildLoginField(),
                  _buildAddSharedPasswordButton(context),
                  _buildShares(context, sessionState, password)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'Login',
        decoration: const InputDecoration(
          hintText: 'Login',
        ),
      ),
    );
  }

  Widget _buildAddSharedPasswordButton(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            child: const Text('Add shared password'),
            onPressed: () async {
              _formKey.currentState?.save();
              if (_formKey.currentState!.validate() &&
                  state is SessionAuthenticated) {
                final formData = _formKey.currentState?.value;
                final passwordCubit = BlocProvider.of<PasswordCubit>(context);
                await passwordCubit.addSharedPassword(
                    state.session.token,
                    SharedPassword(
                      id: password.id as String,
                      login: formData!['Login'],
                    ));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildShare(BuildContext context, SessionState sessionState,
      SharedPassword sharedPassword) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(sharedPassword.login),
            _buildUnsharePasswordButton(context, sessionState, sharedPassword)
          ],
        ),
      ),
    );
  }

  Widget _buildUnsharePasswordButton(BuildContext context,
      SessionState sessionState, SharedPassword sharedPassword) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (sessionState is SessionAuthenticated) {
            final passwordCubit = BlocProvider.of<PasswordCubit>(context);
            await passwordCubit.deleteSharedPassword(
                sessionState.session.token, sharedPassword.id, password);
          }
        },
        child: const Text('Unshare password'),
      ),
    );
  }

  Widget _buildShares(
      BuildContext context, SessionState sessionState, Password password) {
    List<Widget> shareWidgets = [];
    for (var i = 0; i < password.sharedTo!.length; i++) {
      shareWidgets.add(
        const Divider(
          color: Colors.black,
        ),
      );
      shareWidgets.add(
        _buildShare(context, sessionState, password.sharedTo!.elementAt(i)),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: shareWidgets,
    );
  }
}
