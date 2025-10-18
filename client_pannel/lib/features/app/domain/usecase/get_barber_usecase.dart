import '../../data/model/barber_model.dart';
import '../repo/barber_repo.dart';

class GetBarberUseCase {
  final BarberRepository repository;

  GetBarberUseCase({required this.repository});

  Stream<BarberModel> call(String barberId) {
    return repository.streamBarber(barberId);
  }
}

