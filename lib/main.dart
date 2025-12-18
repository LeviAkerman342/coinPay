import 'package:flutter/material.dart';
import 'core/storage/app_storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive и хранилище
  await AppStorage.init();

  runApp(const MyApp());
}