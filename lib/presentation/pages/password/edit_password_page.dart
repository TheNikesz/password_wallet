import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../domain/models/password.dart';
import '../../cubits/auth/session_cubit.dart';
import '../../cubits/password/password_cubit.dart';

class EditPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final Password password;

  EditPasswordPage({super.key, required this.password});

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
              _buildLoginField(),
              _buildWebsiteAddressField(),
              _buildDescriptionField(),
              _buildPasswordField(),
              _buildEditPasswordButton(context),
            ],
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
        initialValue: password.login,
        decoration: const InputDecoration(
          hintText: 'Login',
        ),
      ),
    );
  }

  Widget _buildWebsiteAddressField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'Website',
        initialValue: password.webAddress,
        decoration: const InputDecoration(
          hintText: 'Website address',
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderTextField(
        name: 'Description',
        initialValue: password.description,
        decoration: const InputDecoration(
          hintText: 'Description',
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

  Widget _buildEditPasswordButton(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            child: const Text('Edit password'),
            onPressed: () async {
              _formKey.currentState?.save();
              if (_formKey.currentState!.validate() &&
                  state is SessionAuthenticated) {
                final formData = _formKey.currentState?.value;
                final passwordCubit = BlocProvider.of<PasswordCubit>(context);
                await passwordCubit.editPassword(
                    state.session.token,
                    Password(
                      password: formData!['Password'],
                      login: formData['Login'],
                      webAddress: formData['Website'],
                      description: formData['Description'],
                    ));
              }
            },
          ),
        );
      },
    );
  }
}
