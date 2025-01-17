import 'package:hive/hive.dart';

class AuthService {
  static Future<bool> checkUserExists(String email, String password) async {
    var box = await Hive.openBox('users');
    var users = box.values.toList();

    for (var user in users) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }
}
