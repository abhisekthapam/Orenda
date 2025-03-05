import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/app/di/di.dart';
import 'package:orenda/core/theme/app_theme.dart';
import 'package:orenda/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:orenda/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:orenda/features/splash/presentation/view/splash_view.dart';
import 'package:orenda/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SplashCubit>()),
        BlocProvider(create: (context) => getIt<RegisterBloc>()),
        BlocProvider(create: (context) => getIt<LoginBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Orenda',
        theme: AppTheme.getApplicationTheme(isDarkMode: false),
        home: SplashView(),
      ),
    );
  }
}
