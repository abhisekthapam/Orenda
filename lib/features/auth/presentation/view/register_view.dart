import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orenda/features/auth/presentation/view/login_view.dart';
import 'package:orenda/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _key = GlobalKey<FormState>();
  final _fnameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _phoneController = TextEditingController(text: '');
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  // Check for camera permission
  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;
  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          context.read<RegisterBloc>().add(
                UploadImage(file: _img!),
              );
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  const Text(
                    "Create an Account",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Stack(
                    children: [
                      Image.asset(
                        MediaQuery.of(context).size.width < 600
                            ? 'assets/images/tt.jpg'
                            : Theme.of(context).brightness == Brightness.dark
                                ? 'assets/images/dark-theme-logo.jpg'
                                : 'assets/images/light-theme-logo.jpg',
                        height:
                            MediaQuery.of(context).size.width < 600 ? 36 : 170,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.grey[300],
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Select an option",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      checkCameraPermission();
                                      _browseImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                    ),
                                    label: const Text('Camera'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _browseImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                    label: const Text('Gallery'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _img != null
                            ? FileImage(_img!)
                            : const AssetImage('assets/images/askProfile.jpg')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _fnameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF565657),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF565657),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF565657),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF565657),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone No.',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF565657),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color(0xFF565657),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phoneNo';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF565657),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF565657),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF565657),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF565657),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(144, 86, 86, 87)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF565657)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(height: 26),
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
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          final registerState =
                              context.read<RegisterBloc>().state;
                          final imageName = registerState.imageName;
                          context.read<RegisterBloc>().add(
                                RegisterStudent(
                                  context: context,
                                  fname: _fnameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  image: imageName,
                                ),
                              );
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                            builder: (context) => LoginView(),
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
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
