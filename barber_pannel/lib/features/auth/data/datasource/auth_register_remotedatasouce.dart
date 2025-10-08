import 'package:barber_pannel/features/auth/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRegisterRemotedatasouce {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


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
      QuerySnapshot querySnapshot = await _firestore.collection('barbers').where(
        'email',
        isEqualTo: email,
      ).get();
      if (querySnapshot.docs.isNotEmpty) {
        return false;
      }
      UserCredential response = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (response.user != null) {
        final barberModel = BarberModel(
        uid: response.user!.uid,
        barberName: barberName,
        ventureName: ventureName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        isVerified: false,
        isBloc: false,
      );

        await _firestore.collection('barbers').doc(response.user?.uid).set(barberModel.toMap());
        return true;
      } else {
        return false;
      }
    }  on FirebaseAuthException catch (e) {
      throw Exception('Auth exepction: ${e.message}');
    }  on FirebaseException catch (e) {
      throw Exception('Database exepction: ${e.message}');
    } catch (e) {
      throw Exception('Database exepction: $e');
    }
  }
}