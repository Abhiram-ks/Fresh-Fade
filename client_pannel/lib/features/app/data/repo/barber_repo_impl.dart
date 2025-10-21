import '../../domain/repo/barber_repo.dart';
import '../datasource/barber_remote_datasource.dart';
import '../model/barber_model.dart';

class BarberRepositoryImpl implements BarberRepository {
  final BarberRemoteDatasource remoteDatasource;

  BarberRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<BarberModel>> streamAllBarbers() {
    try {
      return remoteDatasource.streamAllBarbers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<BarberModel> streamBarber(String barberId) {
    try {
      return remoteDatasource.streamBarber(barberId);
    } catch (e) {
      rethrow;
    }
  }
}

