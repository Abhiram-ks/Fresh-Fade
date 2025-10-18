import '../entity/user_entity.dart';

abstract class UserRepo {
  // Get user stream
  Stream<UserEntity> getUserStream(String uid);
  // Update user profile
  Future<bool> update({required String uid, required String name, required String phone, required String address, required int age, required String photoUrl});
}

