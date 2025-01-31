import 'package:flutter/material.dart';
import 'package:orenda/app/app.dart';
import 'package:orenda/app/di/di.dart';
import 'package:orenda/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // await HiveService().clearStudentBox();

  await initDependencies();

  runApp(
    App(),
  );
}
