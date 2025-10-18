
import '../../domain/repo/image_picker_repo.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePicker _imagePicker;

  ImagePickerRepositoryImpl(this._imagePicker);

  @override
  Future<String?> pickImagePath() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}
