import '../repo/barber_service_repository.dart';

class ModificationBarberUsecase {
  final BarberServiceRepository repository;

  ModificationBarberUsecase({required this.repository});
  

  //! update barber service use case
  Future<bool> updateService({
    required String barberId,
    required String serviceName,
    required double serviceRate,
  }) {
    return repository.updateService(
      barberId: barberId,
      serviceName: serviceName,
      serviceRate: serviceRate,
    );
  }


  //! delete barber service use case
  Future<bool> deleteService({
    required String barberId,
    required String serviceName,
  }) {
    return repository.deleteService(
      barberId: barberId,
      serviceName: serviceName,
    );
  }
}
