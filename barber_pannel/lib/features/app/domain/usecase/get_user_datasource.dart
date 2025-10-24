import 'package:barber_pannel/features/app/domain/repo/user_repo.dart' show UserRepository;

import '../entity/user_entity.dart';

class GetUserDatasource {
  final UserRepository userRepository;
  GetUserDatasource({required this.userRepository});

  Stream<UserEntity?> call(String userId)  {
    return userRepository.getUser(userId: userId);
  }
}
