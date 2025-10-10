import '../entity/service_entity.dart';

abstract class ServiceManagementRepository {
  Future<bool> uploadService(String serviceName);
  Future<bool> updateService({
    required String serviceId,
    required String updatedService,
  });
  Future<bool> deleteService({required String serviceId});
  Stream<List<ServiceEntity>> getServiceStream();
}
