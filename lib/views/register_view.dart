import 'package:flutter/material.dart';
import 'package:orenda/database/models/user_model.dart';
import 'package:orenda/views/login_view.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void registerUser() async {
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    final user = UserModel(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );

    // await HiveDatabase.addUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration Successful!'),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

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
                    MediaQuery.of(context).size.width < 600
                        ? 'assets/images/login-pic.jpg'
                        : Theme.of(context).brightness == Brightness.dark
                            ? 'assets/images/dark-theme-logo.jpg'
                            : 'assets/images/light-theme-logo.jpg',
                    height: MediaQuery.of(context).size.width < 600 ? 270 : 170,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 15),
                    PasswordTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    PasswordTextField(
                      controller: confirmPasswordController,
                      labelText: 'Confirm Password',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: phoneController,
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
                        onPressed: registerUser,
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
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.labelText,
    required this.icon,
    required this.controller,
  });

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
      controller: widget.controller,
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
