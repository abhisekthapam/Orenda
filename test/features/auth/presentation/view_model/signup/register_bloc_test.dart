import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class Failure {
  final String message;
  Failure(this.message);
}

class RegisterUserParams {
  final String fname;
  final String email;
  final String phone;
  final String username;
  final String password;

  RegisterUserParams({
    required this.fname,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
  });
}

class UploadImageParams {
  final File file;
  UploadImageParams({required this.file});
}

class MockRegisterUseCase {
  Future<Either<Failure, String>> call(RegisterUserParams params) async {
    if (params.fname.isNotEmpty && params.email.isNotEmpty) {
      return Right('Registration Successful');
    } else {
      return Left(Failure('Invalid data'));
    }
  }
}

class MockUploadImageUsecase {
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    if (params.file.path.endsWith('.jpg') ||
        params.file.path.endsWith('.png')) {
      return Right('image_uploaded.jpg');
    } else {
      return Left(Failure('Invalid image file'));
    }
  }
}

class RegisterBloc {
  final MockRegisterUseCase registerUseCase;
  final MockUploadImageUsecase uploadImageUsecase;
  final StreamController<String> _controller = StreamController<String>();

  Stream<String> get stream => _controller.stream;

  RegisterBloc({
    required this.registerUseCase,
    required this.uploadImageUsecase,
  });

  void add(dynamic event) async {
    if (event is RegisterStudent) {
      var result = await registerUseCase.call(RegisterUserParams(
        fname: event.fname,
        email: event.email,
        phone: event.phone,
        username: event.username,
        password: event.password,
      ));
      result.fold(
        (failure) => _controller.add(failure.message),
        (successMessage) => _controller.add(successMessage),
      );
    } else if (event is UploadImage) {
      var result =
          await uploadImageUsecase.call(UploadImageParams(file: event.file));
      result.fold(
        (failure) => _controller.add(failure.message),
        (successMessage) => _controller.add(successMessage),
      );
    }
  }

  void close() {
    _controller.close();
  }
}

class RegisterStudent {
  final String fname;
  final String email;
  final String phone;
  final String username;
  final String password;

  RegisterStudent({
    required this.fname,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
  });
}

class UploadImage {
  final File file;

  UploadImage({required this.file});
}

void main() {
  group('RegisterBloc Tests', () {
    late RegisterBloc registerBloc;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockUploadImageUsecase mockUploadImageUsecase;

    setUp(() {
      mockRegisterUseCase = MockRegisterUseCase();
      mockUploadImageUsecase = MockUploadImageUsecase();
      registerBloc = RegisterBloc(
        registerUseCase: mockRegisterUseCase,
        uploadImageUsecase: mockUploadImageUsecase,
      );
    });

    tearDown(() {
      registerBloc.close();
    });

    testWidgets('RegisterStudent with valid input', (tester) async {
      registerBloc.add(RegisterStudent(
        fname: 'Abhisek',
        email: 'abhisek@gmail.com',
        phone: '1234567890',
        username: 'abhisek',
        password: 'abhisek123',
      ));
      expectLater(
        registerBloc.stream,
        emits('Registration Successful'),
      );
    });

    testWidgets('RegisterStudent with missing fields', (tester) async {
      registerBloc.add(RegisterStudent(
        fname: '',
        email: '',
        phone: '',
        username: '',
        password: '',
      ));
      expectLater(
        registerBloc.stream,
        emits('Invalid data'),
      );
    });

    testWidgets('UploadImage with valid file', (tester) async {
      registerBloc.add(UploadImage(file: File('path/to/image.jpg')));
      expectLater(
        registerBloc.stream,
        emits('image_uploaded.jpg'),
      );
    });

    testWidgets('UploadImage with invalid file', (tester) async {
      registerBloc.add(UploadImage(file: File('path/to/image.txt')));
      expectLater(
        registerBloc.stream,
        emits('Invalid image file'),
      );
    });

    testWidgets('UploadImage with unsupported file type', (tester) async {
      registerBloc.add(UploadImage(file: File('path/to/document.pdf')));
      await expectLater(
        registerBloc.stream,
        emitsInOrder(['Invalid image file']),
      ).timeout(Duration(seconds: 3));
    });
  });
}
