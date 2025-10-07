import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/service_model.dart';

class ServiceRemoteDatasource  {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ServiceRemoteDatasource();
  
  //! Upload Services
  Future<bool> uploadService(String serviceName)async{

    try {
      final serviceId = firestore.collection('services').doc().id;
      await firestore.collection('services').doc(serviceId).set({
      'id': serviceId,
      'name': serviceName
      });
       return true;
    } catch (e) {
      throw Exception('Unexpect error: $e. Please try again');
    }
  }
  
  //! Update Services
   Future<bool> updateService({required String serviceId, required String updatedService}) async{
    try {
      await firestore.collection('services').doc(serviceId).update({'name':updatedService});

      return true;
    } catch (e) { 
      throw Exception('Unexpect error: $e. Please try again');
    }
   }
   

   //! Delete Services
   Future<bool> deleteService({required String serviceId}) async{
    try {
      await firestore.collection('services').doc(serviceId).delete();
      return true;
    } catch (e) {
      throw Exception('Unexpect error: $e. Please try again');
    }
   }

   //! Fetch Services 
   Stream<List<ServiceModel>> getServiceStream() {
    try {
      return firestore.collection('services').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return ServiceModel.fromFirestore(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}