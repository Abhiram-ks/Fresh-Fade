abstract class AuthRepository {
  Future<bool> loginAdmin({
    required String email,
    required String password,
  });
}
