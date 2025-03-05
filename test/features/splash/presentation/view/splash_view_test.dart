import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class SplashState {}

class SplashLoaded extends SplashState {
  final String message;
  SplashLoaded(this.message);
}

class MockSplashCubit extends Cubit<SplashState> {
  final String someArgument;
  MockSplashCubit(this.someArgument) : super(SplashState());
  Future<void> init(String argument) async {
    emit(SplashLoaded(argument));
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MockSplashCubit, SplashState>(
      builder: (context, state) {
        if (state is SplashLoaded) {
          return Scaffold(
            body: Center(
              child: Text(state.message), 
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

void main() {
  testWidgets('SplashView displays message', (WidgetTester tester) async {
    final mockCubit = MockSplashCubit('Restaurant Orenda');
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockCubit,
          child: SplashView(),
        ),
      ),
    );
    await mockCubit
        .init('Restaurant Orenda');
    await tester
        .pump(); 
    expect(find.text('Restaurant Orenda'), findsOneWidget);
  });

  testWidgets('Shows loading indicator initially',
      (WidgetTester tester) async {
    final mockCubit = MockSplashCubit('Restaurant Orenda');
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockCubit,
          child: SplashView(),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Handles empty message', (WidgetTester tester) async {
    final mockCubit = MockSplashCubit('');
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockCubit,
          child: SplashView(),
        ),
      ),
    );
    await mockCubit.init(''); 
    await tester
        .pump(); 
    expect(find.text(''), findsOneWidget);
  });
}
