import 'package:orenda/core/usecases/usescase.dart';
import 'package:orenda/feature/auth/data/models/auth_model.dart';
import 'package:orenda/feature/auth/domain/repositories/auth_repository.dart';

class RegisterUser implements UseCase<void, AuthModel> {
  final AuthRepository authRepository;

  RegisterUser({required this.authRepository});

  @override
  Future<void> call(AuthModel authModel) async {
    return await authRepository.registerUser(authModel);
  }
}
