import 'package:barber_pannel/features/app/data/datasource/service_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/entity/service_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDatasource remoteDatasource;

  ServiceRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<ServiceEntity>> streamServices() {
    try {
      return remoteDatasource.streamServices().map((serviceModels) {
        return serviceModels.map((model) => model as ServiceEntity).toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}

