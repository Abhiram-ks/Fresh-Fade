import 'package:barber_pannel/features/auth/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberRemoteDatasource {
  final FirebaseFirestore firestore;

  BarberRemoteDatasource({required this.firestore});

  Stream<BarberModel> streamBarber(String barberId) {
   try {
    return firestore
    .collection('barbers')
    .doc(barberId)
    .snapshots()
    .map((event) => BarberModel.fromMap(
      event.data() ?? {}, event.id));
   } catch (e) {
    throw Exception(e);
   }
  }

  
}