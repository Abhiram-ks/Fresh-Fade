import '../repo/password_repo.dart';

class PasswordUsecase {
  final PasswordRepository passwordRepository;

  PasswordUsecase({required this.passwordRepository});

  // Verify Password Email
  Future<bool> verifyPasswordResetEmail(String email) async {
    return await passwordRepository.verifyPasswordEmail(email);
  }

  // Send Password Email
  Future<bool> sendPasswordResetEmail(String email) async {
    return await passwordRepository.sendPasswordEmail(email);
  }

}