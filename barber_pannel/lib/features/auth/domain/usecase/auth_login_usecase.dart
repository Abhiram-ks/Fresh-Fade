import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_login_repo.dart';

class LoginBarberUseCase {
  final AuthLoginRepository repository;

  LoginBarberUseCase({required this.repository});

  Future<BarberEntity> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginBarber(
      email: email,
      password: password,
    );
  }
}

