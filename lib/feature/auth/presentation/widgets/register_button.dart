import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/feature/auth/data/models/auth_model.dart';
import 'package:orenda/feature/auth/presentation/bloc/auth_cubit.dart';

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final authModel = AuthModel(
          fullName: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          phone: '1234567890',
        );

        context.read<AuthCubit>().registerUserToApp(authModel);
      },
      child: const Text('Register'),
    );
  }
}
