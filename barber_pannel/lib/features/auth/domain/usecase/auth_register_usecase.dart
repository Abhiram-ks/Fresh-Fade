import 'package:barber_pannel/features/auth/domain/repo/auth_register_repo.dart';

class RegisterBarberUseCase {
  final AuthRepository repository;

  RegisterBarberUseCase({required this.repository});

  Future<bool> call({
    required String barberName,
    required String ventureName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
    required bool isBloc,
    required bool isVerified,
  }) async {
    return await repository.registerBarber(
      barberName: barberName,
      ventureName: ventureName,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      password: password,
      isBloc: isBloc,
      isVerified: isVerified,
    );
  }
}