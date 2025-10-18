import '../../data/model/barber_model.dart';
import '../repo/barber_repo.dart';

class GetAllBarbersUseCase {
  final BarberRepository repository;

  GetAllBarbersUseCase({required this.repository});

  Stream<List<BarberModel>> call() {
    return repository.streamAllBarbers();
  }
}

