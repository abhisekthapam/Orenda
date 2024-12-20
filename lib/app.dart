import 'package:flutter/material.dart';
import 'package:orenda/views/login_view.dart';
import 'package:orenda/views/onboarding_screen_view.dart';
import 'package:orenda/views/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider()..loadTheme(),
      child: const AppStarter(),
    );
  }
}

class AppStarter extends StatefulWidget {
  const AppStarter({super.key});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> {
  bool? _firstLaunch;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('firstLaunch') ?? true;

    setState(() {
      _firstLaunch = firstLaunch;
    });

    if (firstLaunch) {
      prefs.setBool('firstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_firstLaunch == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final ThemeData theme = themeProvider.isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.white,
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(
                    fontFamily: 'Roboto Regular',
                  ),
                  bodyMedium: TextStyle(
                    fontFamily: 'Roboto Regular',
                  ),
                ),
              )
            : ThemeData.light().copyWith(
                primaryColor: Colors.black,
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(
                    fontFamily: 'Roboto Regular',
                  ),
                  bodyMedium: TextStyle(
                    fontFamily: 'Roboto Regular',
                  ),
                ),
              );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: _firstLaunch! ? const OnboardingScreen() : const Login(),
        );
      },
    );
  }
}
