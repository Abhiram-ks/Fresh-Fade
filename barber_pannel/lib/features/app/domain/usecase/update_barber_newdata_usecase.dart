import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';

class UpdateBarberNewdataUsecase {
  final BarberRepository repo;

  UpdateBarberNewdataUsecase({required this.repo});

  Future<bool> call({
    required String uid,
    required String imageUrl,
    required String gender,
  }) async {
    return await repo.uploadNewField(uid: uid, imageUrl: imageUrl, gender: gender);
  }
}