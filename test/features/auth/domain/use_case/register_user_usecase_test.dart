import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orenda/core/error/failure.dart';
import 'package:orenda/features/auth/domain/entity/auth_entity.dart';
import 'package:orenda/features/auth/domain/repository/auth_repository.dart';
import 'package:orenda/features/auth/domain/use_case/register_user_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);

    registerFallbackValue(const AuthEntity(
      fname: "Abhisek Thapa",
      email: "abhisekthapa@gmail.com",
      phone: "9876543210",
      username: "abhisekthapa",
      password: "securePassword",
      image: null,
    ));
  });

  testWidgets('Register user successfully', (WidgetTester tester) async {
    when(() => repository.registerStudent(any()))
        .thenAnswer((_) async => const Right(null));

    final params = RegisterUserParams(
      fname: "Abhisek Thapa",
      email: "abhisekthapa@gmail.com",
      phone: "9876543210",
      username: "abhisekthapa",
      password: "securePassword",
      image: null,
    );

    final result = await useCase(params);

    expect(result, const Right(null));

    verify(() => repository.registerStudent(any())).called(1);
  });

  testWidgets('Return failure when registration fails',
      (WidgetTester tester) async {
    when(() => repository.registerStudent(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: "Registration failed")));

    final params = RegisterUserParams(
      fname: "Abhisek Thapa",
      email: "abhisekthapa@gmail.com",
      phone: "9876543210",
      username: "abhisekthapa",
      password: "securePassword",
      image: null,
    );

    final result = await useCase(params);

    expect(result, const Left(ApiFailure(message: "Registration failed")));

    verify(() => repository.registerStudent(any())).called(1);
  });

  testWidgets('Return Failure if repository throws an exception',
      (WidgetTester tester) async {
    when(() => repository.registerStudent(any())).thenAnswer((_) async =>
        const Left(ApiFailure(message: "Unexpected error occurred")));

    final params = RegisterUserParams(
      fname: "Abhisek Thapa",
      email: "abhisekthapa@gmail.com",
      phone: "9876543210",
      username: "abhisekthapa",
      password: "securePassword",
      image: null,
    );

    final result = await useCase(params);

    expect(
        result, const Left(ApiFailure(message: "Unexpected error occurred")));

    verify(() => repository.registerStudent(any())).called(1);
  });

  testWidgets('Return failure when username is already taken',
      (WidgetTester tester) async {
    when(() => repository.registerStudent(any())).thenAnswer((_) async =>
        const Left(ApiFailure(message: "Username already exists")));

    final params = RegisterUserParams(
      fname: "Abhisek Thapa",
      email: "abhisekthapa@gmail.com",
      phone: "9876543210",
      username: "abhisekthapa",
      password: "securePassword",
      image: null,
    );

    final result = await useCase(params);

    expect(result, const Left(ApiFailure(message: "Username already exists")));

    verify(() => repository.registerStudent(any())).called(1);
  });

  tearDown(() {
    reset(repository);
  });
}
