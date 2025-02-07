import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orenda/core/error/failure.dart';
import 'package:orenda/features/auth/domain/repository/auth_repository.dart';
import 'package:orenda/features/auth/domain/use_case/upload_image_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockAuthRepository repository;
  late UploadImageUsecase usecase;
  late MockFile mockFile;

  setUp(() {
    repository = MockAuthRepository();
    usecase = UploadImageUsecase(repository);
    mockFile = MockFile();
    registerFallbackValue(mockFile);
  });

  testWidgets('Return URL when upload is successful', (WidgetTester tester) async {
    when(() => repository.uploadProfilePicture(any()))
        .thenAnswer((_) async => const Right("https://example.com/profile.jpg"));

    final params = UploadImageParams(file: mockFile);
    final result = await usecase(params);

    expect(result, const Right("https://example.com/profile.jpg"));

    verify(() => repository.uploadProfilePicture(any())).called(1);
  });

  testWidgets('Return failure when upload fails', (WidgetTester tester) async {
    when(() => repository.uploadProfilePicture(any()))
        .thenAnswer((_) async => const Left(ApiFailure(message: "Image upload failed")));

    final params = UploadImageParams(file: mockFile);
    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: "Image upload failed")));

    verify(() => repository.uploadProfilePicture(any())).called(1);
  });

  tearDown(() {
    reset(repository);
  });
}
