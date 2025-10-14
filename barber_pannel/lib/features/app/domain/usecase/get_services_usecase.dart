import 'package:barber_pannel/features/app/domain/entity/service_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase({required this.repository});

  Stream<List<ServiceEntity>> call() {
    return repository.streamServices();
  }
}

