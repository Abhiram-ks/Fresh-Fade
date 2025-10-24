import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';

abstract class UserRepository {
  Stream<UserEntity?> getUser({required String userId});
}