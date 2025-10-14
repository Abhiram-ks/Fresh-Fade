import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';

class UpdateBarberUseCase {
  final BarberRepository repository;

  UpdateBarberUseCase({required this.repository});

  Future<bool> call({
    required String uid,
    String? barberName,
    String? ventureName,
    String? phoneNumber,
    String? address,
    String? image,
    int? age,
  }) {
    return repository.updateBarber(
      uid: uid,
      barberName: barberName,
      ventureName: ventureName,
      phoneNumber: phoneNumber,
      address: address,
      image: image,
      age: age,
    );
  }
}

