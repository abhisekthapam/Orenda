import 'package:orenda/feature/auth/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<void> registerUser(AuthModel authModel);
}
