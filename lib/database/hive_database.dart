import 'package:hive/hive.dart';

import 'models/user_model.dart';

class HiveDatabase {
  static const String userBoxName = 'userBox';

  static Future<void> init() async {
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>(userBoxName);
  }

  static Future<void> addUser(UserModel user) async {
    final box = Hive.box<UserModel>(userBoxName);
    await box.add(user);
  }

  static List<UserModel> getUsers() {
    final box = Hive.box<UserModel>(userBoxName);
    return box.values.toList();
  }
}
