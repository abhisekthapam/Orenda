part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class UploadImage extends RegisterEvent {
  final File file;

  const UploadImage({
    required this.file,
  });
}

class RegisterStudent extends RegisterEvent {
  final BuildContext context;
  final String fname;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String? image;

  const RegisterStudent({
    required this.context,
    required this.fname,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });
}
