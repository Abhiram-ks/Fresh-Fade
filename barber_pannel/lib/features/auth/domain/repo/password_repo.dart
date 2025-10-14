abstract class PasswordRepository {
  
  // Verify Password Reset Email
  Future<bool> verifyPasswordEmail(String email);

  // Send Password Reset Email
  Future<bool> sendPasswordEmail(String email);
}