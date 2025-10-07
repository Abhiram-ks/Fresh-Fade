import 'package:bloc/bloc.dart';
import '../../../../domain/usecase/pick_image_usecase.dart';
import 'package:flutter/foundation.dart';
part 'image_picker_event.dart';
part 'image_picker_state.dart';

class PickImageBloc extends Bloc<PickImageEvent, PickImageState> {
  final PickImageUseCase pickImageUseCase;
  PickImageBloc(this.pickImageUseCase) : super(PickImageInitial()) {
     on<ClearImageAction>((event, emit) {
        emit(PickImageInitial());
        });
    on<ImagePickerEvent>((event, emit) async{
       emit(ImagePickerLoading());
      try { 
        if (kIsWeb) {
      
          final imageBytes = await pickImageUseCase.pickImageBytes();
          if (imageBytes != null) {
            emit(ImagePickerSuccess(imageBytes: imageBytes));
          }else {
             emit(ImagePickerError('Please select an image.'));
          }
        }  else {
          final imagePath = await pickImageUseCase.call();
          if (imagePath != null) {
            emit(ImagePickerSuccess(imagePath: imagePath));
          } else {
            emit(ImagePickerError('Please select an image.'));
          }
        }
      } catch (e) {
        emit(ImagePickerError("An Error occured:"));
      }
    });
  
  }
}
