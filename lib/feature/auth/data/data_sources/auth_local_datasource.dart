import 'package:hive/hive.dart';
import 'package:orenda/feature/auth/data/models/auth_model.dart';

class AuthLocalDataSource {
  final Box _userBox = Hive.box('users');

  Future<void> saveUser(AuthModel authModel) async {
    await _userBox.put(authModel.email, authModel);
  }

  AuthModel? getUser(String email) {
    return _userBox.get(email);
  }
}
