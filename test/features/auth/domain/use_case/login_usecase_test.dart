import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orenda/app/shared_prefs/token_shared_prefs.dart';
import 'package:orenda/core/error/failure.dart';
import 'package:orenda/features/auth/domain/repository/auth_repository.dart';
import 'package:orenda/features/auth/domain/use_case/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockAuthRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    useCase = LoginUseCase(repository, tokenSharedPrefs);

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right("mock_token"));

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => repository.loginStudent(any(), any()))
        .thenAnswer((_) async => const Right("mock_token"));
  });

  testWidgets('Return token when login is successful',
      (WidgetTester tester) async {
    final result = await useCase(
        const LoginParams(username: "abhisek", password: "abhisek"));

    expect(result, const Right("mock_token"));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);
  });

  testWidgets('Return failure when login fails', (WidgetTester tester) async {
    when(() => repository.loginStudent(any(), any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: "Invalid credentials")));

    final result = await useCase(
        const LoginParams(username: "wrongUser", password: "WrongPassword"));

    expect(result, const Left(ApiFailure(message: "Invalid credentials")));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verifyNever(() => tokenSharedPrefs.saveToken(any()));
  });

  testWidgets('Save token after successful login', (WidgetTester tester) async {
    final result = await useCase(
        const LoginParams(username: "abhisek", password: "abhisek"));

    expect(result, const Right("mock_token"));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken("mock_token")).called(1);
  });

  testWidgets('Return Failure if repository throws an exception',
      (WidgetTester tester) async {
    when(() => repository.loginStudent(any(), any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: "Server error")));

    final result = await useCase(
        const LoginParams(username: "abhisek", password: "abhisek"));

    expect(result, const Left(ApiFailure(message: "Server error")));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verifyNever(() => tokenSharedPrefs.saveToken(any()));
  });

  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
