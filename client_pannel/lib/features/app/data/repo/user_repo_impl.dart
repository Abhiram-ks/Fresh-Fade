import '../../domain/entity/user_entity.dart';
import '../../domain/repo/user_repo.dart';
import '../datasource/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepo {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity> getUserStream(String uid) {
    try {
      return remoteDataSource.getUserStream(uid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required String uid, required String name, required String phone, required String address, required int age, required String photoUrl}) async {
    try {
      return await remoteDataSource.update(uid: uid, name: name, phone: phone, address: address, age: age, photoUrl: photoUrl);
    } catch (e) {
       rethrow; 
    }
  }
}

