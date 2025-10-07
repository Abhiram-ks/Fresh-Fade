import 'package:admin_pannel/features/data/datasource/auth_local_datasource.dart';
import 'package:admin_pannel/features/domain/repo/auth_repo.dart';

class LoginAdminUseCase {
  final AuthRepository repository;
  final AuthLocalDatasource localDb;

  LoginAdminUseCase({
    required this.repository,
    required this.localDb,
  });

  Future<bool> execute({
    required String email,
    required String password,
  }) async {
    final bool response = await repository.loginAdmin(
      email: email,
      password: password,
    );

    if (response) {
      await localDb.saveAdminLogin();
      return true;
    } else {
      return false;
    }
  }
}