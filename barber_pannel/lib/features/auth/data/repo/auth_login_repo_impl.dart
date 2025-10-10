import 'dart:developer';

import 'package:barber_pannel/core/error/auth_exceptions.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_login_remotedatasoucre.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_login_repo.dart';

class AuthLoginRepositoryImpl implements AuthLoginRepository {
  final AuthLoginRemotedatasource remoteDataSource;

  AuthLoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BarberEntity> loginBarber({
    required String email,
    required String password,
  }) async {
    try {
      final barberModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      log('Login successful: ${barberModel.toEntity()}');
      return barberModel.toEntity();
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

