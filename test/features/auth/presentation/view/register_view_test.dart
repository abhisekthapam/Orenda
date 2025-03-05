import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/features/auth/presentation/view/register_view.dart';
import 'package:orenda/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mockito/mockito.dart';

class MockRegisterBloc extends Mock implements RegisterBloc {}

void main() {
  late MockRegisterBloc mockRegisterBloc;
  
  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
  });

  Widget createTestWidget() {
    return BlocProvider<RegisterBloc>(
      create: (context) => mockRegisterBloc,
      child: const MaterialApp(
        home: RegisterView(),
      ),
    );
  }

  testWidgets('RegisterView UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Create an Account"), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text("Register"), findsOneWidget);
  });

  testWidgets('Fill in text fields and submit form', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.enterText(find.byType(TextFormField).at(0), "Abhisek Thapa");
    await tester.enterText(find.byType(TextFormField).at(1), "abhisek@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "1234567890");
    await tester.enterText(find.byType(TextFormField).at(3), "abhisek");
    await tester.enterText(find.byType(TextFormField).at(4), "abhisek123");
    await tester.tap(find.text("Register"));
    await tester.pump();
    expect(find.text("Please enter full name"), findsNothing);
    expect(find.text("Please enter email"), findsNothing);
  });

  testWidgets('Register button disabled when form is incomplete', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.enterText(find.byType(TextFormField).at(0), "Abhisek Thapa");
    await tester.enterText(find.byType(TextFormField).at(1), "abhisek@gmail.com");
    await tester.tap(find.text("Register"));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
