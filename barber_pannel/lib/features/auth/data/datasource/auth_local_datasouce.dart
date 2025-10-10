import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  static const _keyId = "BARBER_ID";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> save({required String barberId}) async {
    try {
      await _storage.write(key: _keyId, value: barberId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> get() async {
    try {
      final String? id = await _storage.read(key: _keyId);
      return id; 
    } catch (_) {
      return null;
    }
  }

  Future<bool> clean() async {
    try {
      await _storage.delete(key: _keyId);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}

