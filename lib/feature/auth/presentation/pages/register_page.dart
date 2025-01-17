import 'package:flutter/material.dart';
import 'package:orenda/feature/auth/presentation/widgets/register_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}
