import '../entity/admin_service_entity.dart';
import '../repo/service_repo.dart';

class GetAdminServicesUseCase {
  final ServiceRepository repository;

  GetAdminServicesUseCase({required this.repository});

  Stream<List<AdminServiceEntity>> call() {
    return repository.streamAdminServices();
  }
}

