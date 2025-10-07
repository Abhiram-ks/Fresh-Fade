import 'package:admin_pannel/features/data/datasource/auth_remote_datasource.dart';
import 'package:admin_pannel/features/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      return await remoteDataSource.storeOrValidateAdminCredentials(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
