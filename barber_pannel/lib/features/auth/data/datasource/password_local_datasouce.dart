import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordRemoteDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  PasswordRemoteDatasource({required this.auth, required this.firestore});

  /// Verify if email exists in barbers collection
  /// 
  /// @param email: The email to verify
  /// @return: True if email exists, false otherwise
  /// @throws: Exception if verification fails
  Future<bool> verifyPasswordEmail(String email) async {
    try {

      final QuerySnapshot query = await firestore
          .collection('barbers')
          .where('email', isEqualTo: email.trim().toLowerCase())
          .get();

      return query.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message ?? e.code}');
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email via Firebase Auth
  /// 
  /// @param email: The email to send reset link to
  /// @return: True if email sent successfully
  /// @throws: Exception if sending fails
  Future<bool> sendPasswordEmail(String email) async {
    try {
      // Validate email format
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Invalid email format');
      }

      await auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'user-not-found':
          throw Exception('No account found with this email');
        case 'too-many-requests':
          throw Exception('Too many requests. Please try again later');
        case 'network-request-failed':
          throw Exception('Network error. Please check your connection');
        default:
          throw Exception('Failed to send reset email: ${e.message ?? e.code}');
      }
    } catch (e) {
      rethrow;
    }
  }
}