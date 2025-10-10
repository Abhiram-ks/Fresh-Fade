import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';

abstract class AuthLoginRepository {
  Future<BarberEntity> loginBarber({
    required String email,
    required String password,
  });
}

