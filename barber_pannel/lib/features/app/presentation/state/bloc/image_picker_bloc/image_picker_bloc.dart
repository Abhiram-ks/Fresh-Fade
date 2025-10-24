import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecase/picker_image_usecase.dart';
part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageUseCase useCase;

  ImagePickerBloc({required this.useCase}) : super(ImagePickerInitial()) {
    on<PickImageAction>(_onPickImage);
    on<ClearImageAction>(_onClearImage);
  }

  Future<void> _onPickImage(
    PickImageAction event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoading());
    try {
      final image = await useCase.call();

      if (image != null) {
        emit(ImagePickerLoaded(imagePath: image));
      } else {
        emit(ImagePickerError(error: 'No image selected'));
      }
    } catch (e) {
      emit(ImagePickerError(error: e.toString()));
    }
  }

  void _onClearImage(
    ClearImageAction event,
    Emitter<ImagePickerState> emit,
  ) {
    emit(ImagePickerInitial());
  }
}
