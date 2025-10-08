

abstract class AuthRepository {
  Future<bool> registerBarber({
    required String barberName,
    required String ventureName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
    required bool isVerified,
    required bool isBloc,
  });
}