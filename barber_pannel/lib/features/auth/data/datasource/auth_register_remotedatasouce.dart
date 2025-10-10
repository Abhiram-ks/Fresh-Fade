import 'package:barber_pannel/core/error/auth_exceptions.dart';
import 'package:barber_pannel/features/auth/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRegisterRemotedatasouce {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AuthRegisterRemotedatasouce({
    required this.firestore,
    required this.auth,
  });

  Future<bool> register({
    required String barberName,
    required String ventureName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
    required bool isVerified,
    required bool isBloc,
  }) async {
    try {
      // Check if email already exists in Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('barbers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw EmailAlreadyExistsException();
      }

      // Create user with Firebase Auth
      UserCredential response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw UserCreationFailedException();
      }

      // Create barber model with timestamp
      final barberModel = BarberModel(
        uid: response.user!.uid,
        barberName: barberName,
        ventureName: ventureName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        isVerified: false,
        isBloc: false,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await firestore
          .collection('barbers')
          .doc(response.user!.uid)
          .set(barberModel.toMap());

      return true;
      
    } on EmailAlreadyExistsException {
      rethrow; // Re-throw custom exceptions
    } on UserCreationFailedException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyExistsException();
        case 'weak-password':
          throw WeakPasswordException();
        case 'invalid-email':
          throw InvalidEmailException();
        case 'network-request-failed':
          throw NetworkException();
        case 'operation-not-allowed':
          throw AuthException(
            'Email/password accounts are not enabled. Please contact support.',
            code: 'operation-not-allowed',
          );
        case 'too-many-requests':
          throw AuthException(
            'Too many registration attempts. Please try again later.',
            code: 'too-many-requests',
          );
        default:
          throw AuthException(
            'Authentication error: ${e.message ?? 'Unknown error'}',
            code: e.code,
          );
      }
    } on FirebaseException catch (e) {
      // Handle Firestore errors
      if (e.code == 'unavailable') {
        throw NetworkException();
      } else if (e.code == 'permission-denied') {
        throw DatabaseException('Permission denied. Please contact support.');
      } else {
        throw DatabaseException('Database error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      // Handle any other unexpected errors
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }
}