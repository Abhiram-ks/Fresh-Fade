import 'dart:io';

import 'package:barber_pannel/features/app/domain/usecase/upload_post_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'upload_post_event.dart';
part 'upload_post_state.dart';


class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  String imagePath = '';
  String description = '';

  final AuthLocalDatasource localDB;
  final CloudinaryService cloudService;
  final UploadPostUseCase uploadPostUseCase;

  UploadPostBloc({
    required this.localDB,
    required this.cloudService,
    required this.uploadPostUseCase,
  }) : super(UploadPostInitial()) {
    on<UploadPostEventRequest>((event, emit) {
      imagePath = event.imagePath;
      description = event.description;
      emit(UploadPostAlert());
    });

    on<UploadPostConfirmEvent>((event, emit) async {
      try {
        emit(UploadPostLoading());

        final barberId = await localDB.get();
        if (barberId == null) {
          emit(UploadPostError(error: 'Barber ID not found'));
          return;
        }

        final imageUrl = await cloudService.uploadImage(File(imagePath));
        if (imageUrl == null) {
          emit(UploadPostError(error: 'Failed to upload image'));
          return;
        }

        final success = await uploadPostUseCase(
          barberId: barberId,
          imageUrl: imageUrl,
          description: description,
        );

        if (success) {
          emit(UploadPostSuccess());
        } else {
          emit(UploadPostError(error: 'Failed to upload post'));
        }
      } catch (e) {
        emit(UploadPostError(error: e.toString()));
      }
    });
  }
}
