
import 'package:admin_pannel/features/domain/repo/service_repo.dart';
import 'package:admin_pannel/features/domain/entity/service_entity.dart';
import '../datasource/service_remote_datasource.dart';

class ServiceManagementRepositoryImpl implements ServiceManagementRepository {
  final ServiceRemoteDatasource dataSource;
  
  ServiceManagementRepositoryImpl({required this.dataSource});

  @override
  Future<bool> uploadService(String serviceName) async {
    try {
      return await dataSource.uploadService(serviceName);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateService({
    required String serviceId,
    required String updatedService,
  }) async {
    try {
      return await dataSource.updateService(
        serviceId: serviceId,
        updatedService: updatedService,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteService({required String serviceId}) async {
    try {
      return await dataSource.deleteService(serviceId: serviceId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ServiceEntity>> getServiceStream() {
    try {
      return dataSource.getServiceStream().map((serviceModels) {
        return serviceModels.map((model) => ServiceEntity(
          id: model.id,
          name: model.name,
        )).toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}