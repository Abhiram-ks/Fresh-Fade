import 'package:admin_pannel/features/domain/entity/service_entity.dart';
import 'package:admin_pannel/features/domain/repo/service_repo.dart';

class FetchServiceUsecase {
  final ServiceManagementRepository repository;

  FetchServiceUsecase(this.repository);

  Stream<List<ServiceEntity>> execute() {
    try {
      return repository.getServiceStream();
    } catch (e) {
      rethrow;
    }
  }
}
