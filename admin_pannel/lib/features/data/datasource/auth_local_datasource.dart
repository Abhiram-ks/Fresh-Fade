import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  static const _keyAdminLogin = "ADMIN_LOG";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> saveAdminLogin() async {
    try {
      await _storage.write(key: _keyAdminLogin, value: "true");
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isAdminLoggedIn() async {
    try {
      final value = await _storage.read(key: _keyAdminLogin);
      return value == "true"; 
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAdminLogin() async {
    try {
      await _storage.delete(key: _keyAdminLogin);
      return true;
    } catch (_) {
      return false;
    }
  }
}

