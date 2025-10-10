import 'package:admin_pannel/features/domain/repo/barber_repo.dart';
import 'package:admin_pannel/features/domain/entity/barber_entity.dart';
import '../datasource/barber_remote_datasource.dart';

class BarberRepositoryImpl implements BarberRepository {
  final BarberRemoteDatasource dataSource;

  BarberRepositoryImpl({required this.dataSource});

  //! Fetch All Barbers Stream (live data)
  @override
  Stream<List<BarberEntity>> getAllBarbersStream() {
    try {
      return dataSource.getAllBarbersStream().map((barberModels) {
        return barberModels.map((model) => model.toEntity()).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  //! Accept Barber
  @override
  Future<bool> acceptBarber({required String barberId}) async {
    try {
      return await dataSource.acceptBarber(barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }

  //! Reject Barber
  @override
  Future<bool> rejectBarber({required String barberId}) async {
    try {
      return await dataSource.rejectBarber(barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }

  //! Bloc & UnBloc Barber
  @override
  Future<bool> updateBlocAndUnBloc({required String uid, required bool val}) async {
    try {
      return await dataSource.updateBlocAndUnBloc(uid: uid, val: val);
    } catch (e) {
      rethrow;
    }
  }
}

