import 'package:barber_pannel/features/app/domain/entity/barber_service_entity.dart';

abstract class BarberServiceRepository {

  /// Upload barber service with rate
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @param serviceRate: Rate/price of the service
  /// @return: True if upload is successful
  /// @throws: Exception with specific error messages
  Future<bool> uploadService({
    required String barberId,
    required String serviceName,
    required double serviceRate,
  });

  /// Get barber services with rate (real-time stream)
  /// 
  /// @param barberId: The barber's unique ID
  /// @return: Stream of list of barber services
  /// @throws: Exception with specific error messages
  Stream<List<BarberServiceEntity>> streamServices({required String barberId});


  /// Delete barber service
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @return: True if delete is successful
  /// @throws: Exception with specific error messages
  Future<bool> deleteService({required String barberId, required String serviceName});


  /// Update barber service
  /// 
  /// @param barberId: The barber's unique ID
  /// @param serviceName: Name of the service
  /// @param serviceRate: Rate/price of the service
  /// @return: True if update is successful
  /// @throws: Exception with specific error messages
  Future<bool> updateService({required String barberId, required String serviceName, required double serviceRate});
}

