import 'package:flutter/material.dart';
import 'package:orenda/app/app.dart';
import 'package:orenda/app/di/di.dart';
import 'package:orenda/core/network/hive_service.dart';
import 'package:orenda/core/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await initDependencies();
  setupLocator();
  runApp(const App());
}
