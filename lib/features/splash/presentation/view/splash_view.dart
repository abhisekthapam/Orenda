import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/features/splash/presentation/view_model/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9B4DFF), 
                  Color(0xFF6600CC), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300, 
                  width: 300,
                  child: Image.asset(
                    'assets/images/splash.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Restaurant Orenda',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    fontFamily: 'Montserrat', 
                  ),
                ),

                const SizedBox(height: 20),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),

                const SizedBox(height: 20),
                const Text(
                  'version: 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Montserrat', 
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 4,
            child: const Text(
              'Developed by: Abhisek Thapa Magar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white60,
                fontStyle: FontStyle.italic,
                fontFamily: 'Montserrat', 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
