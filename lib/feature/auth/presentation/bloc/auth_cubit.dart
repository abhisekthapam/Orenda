import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orenda/feature/auth/data/models/auth_model.dart';
import 'package:orenda/feature/auth/data/repositories/auth_repository_impl.dart';

class AuthCubit extends Cubit<bool> {
  final RegisterUser registerUser;

  AuthCubit({required this.registerUser}) : super(false);

  Future<void> registerUserToApp(AuthModel authModel) async {
    try {
      await registerUser(authModel);
      emit(true);  // User registered successfully
    } catch (_) {
      emit(false);  // Registration failed
    }
  }
}
