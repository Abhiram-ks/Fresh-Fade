import '../repo/auth_repo.dart';

class AuthUsecase {
  final AuthRepo authRepo;
  AuthUsecase({required this.authRepo});

  Future<String> signInwithGoogle() async {
    return await authRepo.signInwithGoogle();
  }
}
