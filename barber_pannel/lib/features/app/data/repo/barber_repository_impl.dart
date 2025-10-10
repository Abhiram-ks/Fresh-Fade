import 'package:barber_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';

class BarberRepositoryImpl implements BarberRepository {
  final BarberRemoteDatasource remoteDatasource;

  BarberRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<BarberEntity> streamBarber(String barberId) {
    try {
      return remoteDatasource.streamBarber(barberId).map((barberModel) => barberModel.toEntity());
    } catch (e) {
      rethrow;
    }
  }
}

