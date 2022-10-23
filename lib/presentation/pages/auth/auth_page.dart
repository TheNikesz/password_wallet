import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../main.dart';
import '../../cubits/auth/session_cubit.dart';

class AuthPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionAuthenticated) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/passwords', (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginField(),
                _buildPasswordField(),
                _buildHashCheckbox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRegisterButton(context),
                    _buildLoginButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'Login',
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Login',
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'Password',
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }

  Widget _buildHashCheckbox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderCheckbox(
        name: 'isPasswordKeptAsHash',
        initialValue: false,
        title: const Text('HMAC'),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Register'),
      onPressed: () async {
        _formKey.currentState?.save();
        if (_formKey.currentState!.validate()) {
          final formData = _formKey.currentState?.value;
          final sessionCubit = BlocProvider.of<SessionCubit>(context);
          final session = await sessionCubit.register(
              login: formData!['Login'],
              password: formData['Password'],
              isPasswordKeptAsHash: formData['isPasswordKeptAsHash']);
        }
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        child: const Text('Log in'),
        onPressed: () async {
          _formKey.currentState?.save();
          if (_formKey.currentState!.validate()) {
            final formData = _formKey.currentState?.value;
            final sessionCubit = BlocProvider.of<SessionCubit>(context);
            await sessionCubit.logIn(
                login: formData!['Login'], password: formData['Password']);
          }
        },
      ),
    );
  }
}
