import 'package:barber_pannel/features/app/data/datasource/barber_service_datasource.dart';
import 'package:barber_pannel/features/app/domain/entity/barber_service_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_service_repository.dart';

class BarberServiceRepositoryImpl implements BarberServiceRepository {
  final BarberServiceDatasource datasource;

  BarberServiceRepositoryImpl({required this.datasource});

  @override
  Future<bool> uploadService({
    required String barberId,
    required String serviceName,
    required double serviceRate,
  }) async {
    try {
      return await datasource.upload(
        barberId: barberId,
        serviceName: serviceName,
        serviceRate: serviceRate,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<BarberServiceEntity>> streamServices({required String barberId}) {
    try {
      return datasource.streamServices(barberId: barberId).map((models) {
        return models.map((model) => model as BarberServiceEntity).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteService({required String barberId, required String serviceName}) async {
    try {
      return await datasource.delete(barberId: barberId, serviceKey: serviceName);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<bool> updateService({required String barberId, required String serviceName, required double serviceRate}) async {
    try {
      return await datasource.update(barberId: barberId, serviceKey: serviceName, serviceRate: serviceRate);
    } catch (e) {
      rethrow;
    }
  }
}

