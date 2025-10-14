import 'package:barber_pannel/features/app/data/model/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRemoteDatasource {
  final FirebaseFirestore firestore;
  
  ServiceRemoteDatasource({required this.firestore});

  /// Stream all services from Firestore
  /// 
  /// @return: Stream of list of ServiceModel
  /// @throws: Exception if streaming fails
  Stream<List<ServiceModel>> streamServices() {
    try {
      return firestore
          .collection('services')
          .orderBy('name')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ServiceModel.fromMap(doc.id, doc.data());
            }).toList();
          });
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message ?? e.code}');
    } catch (e) {
      rethrow;
    }
  }
}
