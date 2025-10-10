import 'dart:developer';

import 'package:barber_pannel/core/error/auth_exceptions.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/features/auth/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthLoginRemotedatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final AuthLocalDatasource authLocalDatasource;

  AuthLoginRemotedatasource({
    required this.auth,
    required this.firestore,
    required this.authLocalDatasource,
  });

  Future<BarberModel> login({
    required String email,
    required String password,
  }) async {
    try {
      log('login email: $email');
      log('login password: $password');
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw UserNotFoundException();
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email. A new verification link has been sent.',
        );
      }

      DocumentSnapshot<Map<String, dynamic>> userDoc = await firestore
          .collection('barbers')
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw UserNotFoundException();
      }

      final userData = userDoc.data()!;
      final response = await authLocalDatasource.save(barberId: user.uid);
      if (!response) {
        throw UnknownException('Failed to save barber id');
      }
      //! Return BarberModel with complete user data
      return BarberModel.fromMap(userData, user.uid);
      
    } on AccountBlockedException {
      rethrow;
    } on EmailNotVerifiedException {
      rethrow;
    } on UserNotFoundException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-not-verified':
          rethrow;
        case 'user-not-found':
          throw UserNotFoundException();
        case 'wrong-password':
          throw InvalidCredentialsException();
        case 'invalid-email':
          throw InvalidEmailException();
        case 'user-disabled':
          throw UserDisabledException();
        case 'invalid-credential':
          throw InvalidCredentialsException();
        case 'network-request-failed':
          throw NetworkException();
        case 'too-many-requests':
          throw AuthException(
            'Too many login attempts. Please try again later.',
            code: 'too-many-requests',
          );
        default:
          throw AuthException(
            'Login failed: ${e.message ?? 'Unknown error'}',
            code: e.code,
          );
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw NetworkException();
      } else if (e.code == 'permission-denied') {
        throw DatabaseException('Permission denied. Please contact support.');
      } else {
        throw DatabaseException('Database error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      throw UnknownException('Login error: ${e.toString()}');
    }
  }
}
