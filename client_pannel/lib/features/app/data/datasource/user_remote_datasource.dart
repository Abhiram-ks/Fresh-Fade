import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource({required this.firestore});

  Stream<UserModel> getUserStream(String uid) {
    try {
      return firestore
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          throw Exception('User not found');
        }
        return UserModel.fromJson(uid, snapshot.data() ?? {});
      });
    } catch (e) {
      throw Exception('Failed to fetch user: ${e.toString()}');
    }
  }


  // Update user profile

  Future<bool> update({required String uid, required String name, required String phone, required String address, required int age, required String photoUrl}) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'photoUrl': photoUrl,
        'name': name,
        'phone': phone,
        'address': address,
        'age': age,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}