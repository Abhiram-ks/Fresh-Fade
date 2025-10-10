
import 'package:barber_pannel/core/error/auth_exceptions.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_register_remotedatasouce.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_register_repo.dart' show AuthRepository;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRegisterRemotedatasouce remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> registerBarber({
    required String barberName,
    required String ventureName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
    required bool isBloc,
    required bool isVerified,
  }) async {
    try {
      return await remoteDataSource.register(
        barberName: barberName,
        ventureName: ventureName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        password: password,
        isBloc: isBloc,
        isVerified: isVerified,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw UnknownException('Registration failed: ${e.toString()}');
    }
  }
}