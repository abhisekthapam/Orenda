import 'package:flutter/material.dart';
import 'package:orenda/views/login_view.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/login-pic.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    const CustomTextField(
                      labelText: 'Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    const CustomTextField(
                      labelText: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 15),
                    const PasswordTextField(
                      labelText: 'Password',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    const PasswordTextField(
                      labelText: 'Confirm Password',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    const CustomTextField(
                      labelText: 'Phone',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Color(0xFFA1A5AE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF565657),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF565657),
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: const Color(0xFF565657),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String labelText;
  final IconData icon;

  const PasswordTextField({
    Key? key,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF565657),
        ),
        prefixIcon: Icon(
          widget.icon,
          size: 20,
          color: const Color(0xFF565657),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: const Color(0xFF565657),
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}
