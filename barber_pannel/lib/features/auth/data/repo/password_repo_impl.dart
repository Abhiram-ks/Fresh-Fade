import 'package:barber_pannel/features/auth/data/datasource/password_local_datasouce.dart';
import 'package:barber_pannel/features/auth/domain/repo/password_repo.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordRemoteDatasource remoteDatasource;

  PasswordRepositoryImpl({required this.remoteDatasource});

  @override
  Future<bool> verifyPasswordEmail(String email) async {
    try {
      return await remoteDatasource.verifyPasswordEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sendPasswordEmail(String email) async {
    try {
      return await remoteDatasource.sendPasswordEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}

