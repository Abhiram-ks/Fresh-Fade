
import '../repo/image_picker_repo.dart';



class PickImageUseCase {
  final ImagePickerRepository repository;

  PickImageUseCase(this.repository);

  Future<String?> call() async {
    return await repository.pickImagePath();
  }

}
