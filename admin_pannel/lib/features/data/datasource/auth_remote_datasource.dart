
import 'package:admin_pannel/service/security/sensitive_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../service/security/hash_password.dart';

class AuthRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> storeOrValidateAdminCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final adminDocRef = _firestore.collection('admin').doc('credentials');
      final adminDoc = await adminDocRef.get();

      final predefinedHashedPassword = hashPassword(SensitiveKeys.adminPassword);

      if (!adminDoc.exists) {
        await adminDocRef.set({
          'email': SensitiveKeys.adminEmail,
          'password': predefinedHashedPassword,
          'createdAt': DateTime.now().toIso8601String(),
        });

        if (email == SensitiveKeys.adminEmail &&  password == predefinedHashedPassword) {
          return true;
        } else {
          return false; 
        }
      }

      final storedEmail = adminDoc['email'];
      final storedHashedPassword = adminDoc['password'];

      if (email == storedEmail && password == storedHashedPassword) {
        return true; 
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}