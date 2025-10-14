import 'package:barber_pannel/features/app/domain/entity/barber_service_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_service_repository.dart';

class GetBarberServiceUsecase {
  final BarberServiceRepository repository;

  GetBarberServiceUsecase({required this.repository});

  Stream<List<BarberServiceEntity>> call(String barberId) {
    return repository.streamServices(barberId: barberId);
  }
}
  
