import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../cubits/auth/session_cubit.dart';

class ChangeMasterPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  ChangeMasterPasswordPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOldPasswordField(),
              _buildNewPasswordField(),
              _buildHashCheckbox(),
              _buildEditMasterPasswordButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOldPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'OldPassword',
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Old password",
        ),
      ),
    );
  }
  
  Widget _buildNewPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'NewPassword',
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "New password",
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

  Widget _buildEditMasterPasswordButton(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            child: const Text('Edit master password'),
            onPressed: () async {
              _formKey.currentState?.save();
              if (_formKey.currentState!.validate() && state is SessionAuthenticated) {
                final formData = _formKey.currentState?.value;
                final sessionCubit = BlocProvider.of<SessionCubit>(context);
                await sessionCubit.changeMasterPassword(token: state.session.token, oldPassword: formData!['OldPassword'], newPassword: formData['NewPassword'], isPasswordKeptAsHash: formData['isPasswordKeptAsHash']);
              }
            },
          ),
        );
      },
    );
  }
}