import '../entity/barber_service_entity.dart';
import '../repo/service_repo.dart';

class GetBarberServicesUseCase {
  final ServiceRepository repository;

  GetBarberServicesUseCase({required this.repository});

  Stream<List<BarberServiceEntity>> call(String barberId) {
    return repository.streamBarberServices(barberId: barberId);
  }
}