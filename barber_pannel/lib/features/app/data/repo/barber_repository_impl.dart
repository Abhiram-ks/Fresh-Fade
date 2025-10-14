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

  @override
  Future<bool> updateBarber({
    required String uid,
    String? barberName,
    String? ventureName,
    String? phoneNumber,
    String? address,
    String? image,
    int? age,
  }) async {
    try {
      return await remoteDatasource.updateBarber(
        uid: uid,
        barberName: barberName,
        ventureName: ventureName,
        phoneNumber: phoneNumber,
        address: address,
        image: image,
        age: age,
      );
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<bool> uploadNewField({
    required String uid,
    required String imageUrl,
    required String gender,
  }) async {
    try {
      return await remoteDatasource.uploadNewField(uid: uid, imageUrl: imageUrl, gender: gender);
    } catch (e) {
      rethrow;
    }
  }
}

