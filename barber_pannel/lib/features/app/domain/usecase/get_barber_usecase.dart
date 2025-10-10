import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';

class GetBarberUseCase {
  final BarberRepository repository;

  GetBarberUseCase({required this.repository});

  Stream<BarberEntity> call(String barberId) {
    return repository.streamBarber(barberId);
  }
}

