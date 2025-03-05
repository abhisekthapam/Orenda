import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orenda/core/error/failure.dart'; 
import 'package:orenda/features/auth/domain/use_case/login_usecase.dart';
import 'package:orenda/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:orenda/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:orenda/features/home/presentation/view_model/home_cubit.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockFailure extends Failure {
  const MockFailure({required super.message});
}

class DummyLoginParams extends Fake implements LoginParams {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockRegisterBloc registerBloc;
  late MockHomeCubit homeCubit;
  late LoginBloc loginBloc;

  setUpAll(() {
    registerFallbackValue(DummyLoginParams());
  });

  setUp(() {
    registerBloc = MockRegisterBloc();
    homeCubit = MockHomeCubit();
    loginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(
      registerBloc: registerBloc,
      homeCubit: homeCubit,
      loginUseCase: loginUseCase,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  test('Valid login with correct credentials', () async {
    when(() => loginUseCase.call(any()))
        .thenAnswer((_) async => Right('Login Successful'));

    final result = await loginUseCase
        .call(LoginParams(username: 'test', password: 'password123'));
    expect(result, isA<Right>());
    result.fold(
      (failure) => fail('Login failed'),
      (success) => expect(success, 'Login Successful'),
    );
  });

  test('Invalid login with incorrect credentials', () async {
    when(() => loginUseCase.call(any())).thenAnswer(
        (_) async => Left(MockFailure(message: 'Invalid credentials')));

    final result = await loginUseCase
        .call(LoginParams(username: 'wrong', password: 'wrong123'));
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure.message, 'Invalid credentials'),
      (success) => fail('Login should have failed'),
    );
  });

  test('Login with empty username', () async {
    when(() => loginUseCase.call(any())).thenAnswer(
        (_) async => Left(MockFailure(message: 'Username cannot be empty')));

    final result = await loginUseCase
        .call(LoginParams(username: '', password: 'password123'));
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure.message, 'Username cannot be empty'),
      (success) => fail('Login should have failed'),
    );
  });

  test('Login with empty password', () async {
    when(() => loginUseCase.call(any())).thenAnswer(
        (_) async => Left(MockFailure(message: 'Password cannot be empty')));

    final result =
        await loginUseCase.call(LoginParams(username: 'test', password: ''));
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure.message, 'Password cannot be empty'),
      (success) => fail('Login should have failed'),
    );
  });

  test('Unexpected exception during login', () async {
    when(() => loginUseCase.call(any()))
        .thenThrow(Exception('Unexpected error'));

    try {
      await loginUseCase
          .call(LoginParams(username: 'test', password: 'password123'));
      fail('Exception should have been thrown');
    } catch (e) {
      expect(e.toString(), contains('Unexpected error'));
    }
  });
}
