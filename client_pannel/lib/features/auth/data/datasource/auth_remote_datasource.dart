import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_local_datasource.dart';

class AuthRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final AuthLocalDatasource localDB;

  AuthRemoteDatasource({required this.auth, required this.googleSignIn, required this.localDB, required this.firestore});


  Future<String> signInwithGoogle() async {
    try {
      // Step 1: Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception(
          'Sign-In cancelled by user. Please try again if you wish to continue.',
        );
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, 
        accessToken: googleAuth.accessToken
      );

      // Step 2: Sign in with Firebase
      final UserCredential userCredential = await auth.signInWithCredential(credential);

      User? user = userCredential.user;
      
      if (user == null) {
        throw Exception(
          'Authentication failed. No user information was returned. Please try signing in again.',
        );
      }

      final String uid = user.uid;

      // Step 3: Check if user exists in Firestore
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // User already exists, save UID to local storage and return
        final response = await localDB.save(uid: uid);
        if (!response) {
          throw Exception('Failed to save user token to local storage');
        }
        return uid;
      } else {
        // User doesn't exist, create new user document
        await firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });
        
        // Save UID to local storage
        final response = await localDB.save(uid: uid);
        if (!response) {
          throw Exception('Failed to save user token to local storage');
        }
        
        return uid;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'Authentication failed: ${e.message ?? "An unexpected error occurred. Please try again."}',
      );
    } catch (e) {
      throw Exception('Sign-in error: ${e.toString()}');
    }
  }
}