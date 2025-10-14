import 'package:barber_pannel/features/app/data/model/barber_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberServiceDatasource {
  final FirebaseFirestore firestore;

  BarberServiceDatasource({required this.firestore});

  /// Upload barber service with rate
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @param serviceRate: Rate/price of the service
  /// @return: True if upload is successful
  /// @throws: Exception with specific error messages
  Future<bool> upload({
    required String barberId,
    required String serviceName,
    required double serviceRate,
  }) async {
    try {

      final DocumentReference barberDoc = firestore
          .collection('individual_barber_services')
          .doc(barberId);

      final docSnapshot = await barberDoc.get();

      Map<String, dynamic> existingServices = {};
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;
        existingServices = (data?['services'] ?? {}) as Map<String, dynamic>;
      }

      if (existingServices.containsKey(serviceName)) {
        throw Exception('Service "$serviceName" already exists. Please update instead.');
      }


      await barberDoc.set({
        'services': {
          serviceName: serviceRate,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  /// Get barber services with rate (real-time stream)
  /// 
  /// @param barberId: The barber's unique ID
  /// @return: Stream of list of barber services
  /// @throws: Exception with specific error messages
  Stream<List<BarberServiceModel>> streamServices({required String barberId}) {
    try {
      if (barberId.isEmpty) {
        throw Exception('Barber ID cannot be empty');
      }

      return firestore
          .collection('individual_barber_services')
          .doc(barberId)
          .snapshots()
          .map((docSnapshot) {
        if (!docSnapshot.exists) {
          return <BarberServiceModel>[];
        }

        final data = docSnapshot.data();
        if (data == null || data['services'] == null) {
          return <BarberServiceModel>[];
        }

        final servicesMap = Map<String, dynamic>.from(data['services']);

        return servicesMap.entries.map((entry) {
          return BarberServiceModel.fromMap(
            barberID: barberId,
            key: entry.key,
            value: entry.value,
          );
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message ?? e.code}');
    } catch (e) {
      rethrow;
    }
  }



  /// Delete barber service
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @return: True if delete is successful
  /// @throws: Exception with specific error messages
  Future<bool> delete({required String barberId, required String serviceKey}) async {
    try {
      await firestore
          .collection('individual_barber_services')
          .doc(barberId)
          .update({'services.$serviceKey': FieldValue.delete()});
      return true;
    } on FirebaseException catch (e) {
      throw Exception('Database error: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  

  /// Update barber service
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @param serviceRate: Rate/price of the service
  /// @return: True if update is successful
  /// @throws: Exception with specific error messages
  Future<bool> update({
    required String barberId,
    required String serviceKey, 
    required double serviceRate}) async {
    try {
      await firestore
          .collection('individual_barber_services')
          .doc(barberId)
          .update({'services.$serviceKey': serviceRate});
      return true;
    } on FirebaseException catch (e) {
      throw Exception('Database error: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

