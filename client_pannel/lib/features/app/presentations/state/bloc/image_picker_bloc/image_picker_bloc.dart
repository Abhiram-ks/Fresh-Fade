import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/domain/usecase/pick_image_usecase.dart';
import 'package:flutter/material.dart';
part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageUseCase usecase;

  ImagePickerBloc({required this.usecase}) : super(ImagePickerInitial()) {
    on<PickImageAction>((event, emit) async {
      try {
        final image = await usecase.call();
        if (image == null) {
          emit(ImagePickerError(error: 'No image selected'));
        } else {
          emit(ImagePickerLoaded(imagePath: image));
        }
      } catch (e) {
        emit(ImagePickerError(error: e.toString()));
      }
    });

    on<ClearImageAction>((event, emit) {
    emit(ImagePickerInitial());
  });
  }
}
