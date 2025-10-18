import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthLocalDatasource {
  final FlutterSecureStorage _store = const FlutterSecureStorage();
  static const _keyID = "user_id";
  

  /// Save the user id to the local storage
  Future<bool> save({required String uid}) async {
    try {
      await _store.write(key: _keyID, value: uid);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Get the user id from the local storage
  Future<String?> get() async {
    try {
      final String? uid = await _store.read(key: _keyID);
      return uid;
    } catch (e) { 
      return null; // Return null if there's an error reading storage
    }
  }


  /// Delete the user id from the local storage
  Future<bool> delete() async {
    try {
      await _store.delete(key: _keyID);
      return true;
    } catch (e) {
      return false; 
    }
  }

  Future<bool> deleteAll() async {
    try {
      await _store.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }

}

