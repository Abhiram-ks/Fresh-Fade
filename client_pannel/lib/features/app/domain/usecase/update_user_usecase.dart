import '../repo/user_repo.dart';

class UpdateUserUseCase {
  final UserRepo userRepo;

  UpdateUserUseCase({required this.userRepo});

  Future<bool> call({
    required String uid, 
    required String name, 
    required String phone, 
    required String address, 
    required int age, 
    required String photoUrl}) async {
    return await userRepo.update(
      uid: uid, 
      name: name, 
      phone: phone, 
      address: address, 
      age: age, 
      photoUrl: photoUrl);
  }
}