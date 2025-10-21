import '../../domain/entity/admin_service_entity.dart';
import '../../domain/entity/barber_service_entity.dart';
import '../../domain/repo/service_repo.dart';
import '../datasource/service_remote_datasource.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDatasource remoteDatasource;

  ServiceRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<AdminServiceEntity>> streamAdminServices() {
    try {
      return remoteDatasource.streamAdminServices();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<BarberServiceEntity>> streamBarberServices({required String barberId}) {
    try {
      return remoteDatasource.streamBarberServices(barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }
}

