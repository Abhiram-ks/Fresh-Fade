import 'package:admin_pannel/features/domain/repo/service_repo.dart';

class ServiceManagementUsecase {
  final ServiceManagementRepository repository;

  ServiceManagementUsecase(this.repository);

  Future<bool> excutedUpload(String serviceName) async {
    return await repository.uploadService(serviceName);
  }

  Future<bool> excutedUpdate({
    required String serviceId,
    required String updatedService,
  }) async {
    return await repository.updateService(
      serviceId: serviceId,
      updatedService: updatedService,
    );
  }

    Future<bool> excutedDelete({required String serviceId}) async {
    return await repository.deleteService(serviceId: serviceId);
  }
}

