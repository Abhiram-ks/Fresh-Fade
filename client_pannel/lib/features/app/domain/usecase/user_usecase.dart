import '../entity/user_entity.dart';
import '../repo/user_repo.dart';

class UserUsecase {
  final UserRepo userRepo;

  UserUsecase({required this.userRepo});

  Stream<UserEntity> getUserStream(String uid) {
    return userRepo.getUserStream(uid);
  }
}

