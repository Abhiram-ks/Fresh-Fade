import 'package:barber_pannel/features/app/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDatasource {
 final FirebaseFirestore firestore;
 UserRemoteDatasource({required this.firestore});
 

 Stream<UserModel?> streamUserData({required String userId}) {
   try {
    return firestore
    .collection('users')
    .doc(userId)
    .snapshots()
    .map((snapshot) {
      if (snapshot.exists) {
        try {
          return UserModel.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>);
        } catch (e) {
          return null;
        }
      }
      return null;
    })
    .handleError((e){
    });
   } catch (e) {
    throw Exception(e);
   }
 }
}