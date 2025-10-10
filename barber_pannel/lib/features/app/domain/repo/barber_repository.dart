import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';

abstract class BarberRepository {
  Stream<BarberEntity> streamBarber(String barberId);
}

