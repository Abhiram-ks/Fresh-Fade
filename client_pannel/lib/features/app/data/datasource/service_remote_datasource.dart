import 'package:client_pannel/features/app/data/model/admin_service_model.dart';
import 'package:client_pannel/features/app/data/model/barber_service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRemoteDatasource {
  final FirebaseFirestore firestore;

  ServiceRemoteDatasource({required this.firestore});

  Stream<List<AdminServiceModel>> streamAdminServices() {
    try {
      return firestore
      .collection('services')
      .snapshots().map((snapshot) => snapshot.docs.map((doc) => AdminServiceModel.fromMap(doc.id, doc.data())).toList());
    
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //Fetch barber services
  Stream<List<BarberServiceModel>> streamBarberServices({required String barberId}) {
   final docRef = firestore
   .collection('individual_barber_services')
   .doc(barberId);

     try {
       return docRef.snapshots().map((docSnapshot) {
         if (!docSnapshot.exists) return <BarberServiceModel>[];

         final data = docSnapshot.data();
         if (data == null || data.isEmpty || data['services'] == null) {
          return <BarberServiceModel>[];
         } 

          final servicesMap = Map<String, dynamic>.from(data['services'] as Map);

          return servicesMap.entries.map((entry) {
            return BarberServiceModel.fromMap(
              barberID: barberId, 
              key: entry.key, 
              value: entry.value);
          }).toList();
       });
      } catch (e) {
       throw Exception(e.toString());
     }
  }
}