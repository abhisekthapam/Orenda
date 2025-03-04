import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/app/di/di.dart';
import 'package:orenda/features/auth/presentation/view/login_view.dart';
import 'package:orenda/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:orenda/features/home/presentation/view_model/home_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription? _accelerometerSubscription;

  HomeCubit() : super(HomeState.initial()) {
    _startListeningToShake();
  }

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: getIt<LoginBloc>(),
              child: LoginView(),
            ),
          ),
        );
      }
    });
  }

  void _startListeningToShake() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double x = event.x;

      if (x < -8) {
        navigateLeft();
      } else if (x > 8) {
        navigateRight();
      }
    });
  }

  void navigateLeft() {
    if (state.selectedIndex > 0) {
      emit(state.copyWith(selectedIndex: state.selectedIndex - 1));
    }
  }

  void navigateRight() {
    if (state.selectedIndex < state.views.length - 1) {
      emit(state.copyWith(selectedIndex: state.selectedIndex + 1));
    }
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    return super.close();
  }
}
