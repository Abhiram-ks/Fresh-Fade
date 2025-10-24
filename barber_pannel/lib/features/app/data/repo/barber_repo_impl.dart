import '../../domain/entity/user_entity.dart';
import '../../domain/repo/user_repo.dart';
import '../datasource/user_remote_datasource.dart';

class UserRepoImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  UserRepoImpl({required this.remoteDatasource});

  @override
  Stream<UserEntity?> getUser({required String userId}) {
    return remoteDatasource.streamUserData(userId: userId);
  }
}