import 'package:admin_pannel/features/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberRemoteDatasource {
  final FirebaseFirestore firestore;

  BarberRemoteDatasource(this.firestore);

  //! Fetch All Barbers
  Stream<List<BarberModel>> getAllBarbersStream() {
    try {
      return firestore
      .collection('barbers')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => BarberModel.fromMap(doc.data(),doc.id)).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch barbers: $e');
    }
  }



  //! Accept Barber
  Future<bool> acceptBarber({required String barberId}) async {
    try {
      await firestore.collection('barbers').doc(barberId).update({'isVerified': true});
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //! Reject Barber
  Future<bool> rejectBarber({required String barberId}) async {
    try {
      await firestore.collection('barbers').doc(barberId).delete();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //! Bloc & UnBloc Barber
  Future<bool> updateBlocAndUnBloc({required String uid, required bool val}) async {
    try {
      await firestore.collection('barbers').doc(uid).update({
        'isBloc': val,
      });
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
