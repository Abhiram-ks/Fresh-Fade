import 'package:admin_pannel/features/domain/entity/barber_entity.dart';
import 'package:admin_pannel/features/domain/repo/barber_repo.dart';

class FetchBarberUsecase {
  final BarberRepository repository;

  FetchBarberUsecase(this.repository);

  Stream<List<BarberEntity>> execute() {
    try {
      return repository.getAllBarbersStream();
    } catch (e) {
      rethrow;
    }
  }
}

