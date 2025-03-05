import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orenda/features/auth/presentation/view/login_view.dart';

void main() {
  testWidgets('LoginView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginView()),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); 
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Username and password fields accept input', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginView()),
    );

    await tester.enterText(find.byKey(const ValueKey('username')), 'testuser');
    await tester.enterText(find.byKey(const ValueKey('password')), 'password123');

    expect(find.text('testuser'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });

  testWidgets('Remember me checkbox works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginView()),
    );

    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);
    await tester.tap(checkbox);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    await tester.tap(checkbox);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);
  });
  testWidgets('Form validation shows error for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginView()),
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });
}
