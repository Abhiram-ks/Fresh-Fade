import '../../domain/repo/auth_repo.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDatasource authRemoteDatasource;
  AuthRepositoryImpl({required this.authRemoteDatasource});

  @override
  Future<String> signInwithGoogle() async {
    try {
      return await authRemoteDatasource.signInwithGoogle();
    } catch (e) {
      throw Exception(e);
    }
  }
}

