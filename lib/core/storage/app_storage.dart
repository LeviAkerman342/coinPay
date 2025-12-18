import 'package:hive_flutter/hive_flutter.dart';

class AppStorage {
  static const String _boxName = 'app_box';
  static const String _keyFirstLaunch = 'is_first_launch';
  static const String _keyLoggedIn = 'is_logged_in'; // потом заменишь на токен или что-то реальное

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  // Первый запуск приложения
  static bool isFirstLaunch() {
    return _box.get(_keyFirstLaunch, defaultValue: true) as bool;
  }

  static Future<void> completeOnboarding() async {
    await _box.put(_keyFirstLaunch, false);
  }

  // Авторизация (заглушка, потом сделаешь нормально)
  static bool isLoggedIn() {
    return _box.get(_keyLoggedIn, defaultValue: false) as bool;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _box.put(_keyLoggedIn, value);
  }

  static Future<void> logout() async {
    await _box.put(_keyLoggedIn, false);
  }
}