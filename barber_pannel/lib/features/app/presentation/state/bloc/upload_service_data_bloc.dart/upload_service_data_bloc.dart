import 'dart:io';

import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecase/update_barber_newdata_usecase.dart';
import '../../cubit/gender_option_cubit/gender_option_cubit.dart';

part 'upload_service_data_event.dart';
part 'upload_service_data_state.dart';

class UploadServiceDataBloc extends Bloc<UploadServiceDataEvent, UploadServiceDataState> {
  final UpdateBarberNewdataUsecase usecase;
  final AuthLocalDatasource localDB;
  final CloudinaryService cloudinary;
  String imagePath = '';
  String genderOption = '';

  UploadServiceDataBloc({required this.cloudinary, required this.localDB, required this.usecase}) : super(UploadServiceDataInitial()) {
    on<UploadServiceDataRequest>((event, emit) {
      imagePath = event.imagePath;
      genderOption = event.gender.name;
      emit(UploadServiceDataLoading());
    });

    on<UploadServiceDataConfirmation>((event, emit) async  {
      emit(UploadServiceDataLoading());

      try {
        String? imageUrl = imagePath;

        if(!imageUrl.startsWith('http')) {
          final String? response = await cloudinary.uploadImage(File(imagePath));
          if(response == null) {
            emit(UploadServiceDataError(error: 'Image upload failed'));
            return;
          }
          imageUrl = response;
        }
        final String? barberID = await localDB.get();
        if(barberID == null) {
          emit(UploadServiceDataError(error: 'Token expired. Please login again.'));
          return;
        }
        final bool response = await usecase.call(uid: barberID, imageUrl: imageUrl, gender: genderOption);
        if(response) {
          emit(UploadServiceDataSuccess());
        } else {
          emit(UploadServiceDataError(error: 'Failed to upload new data'));
        }
      } catch (e) {
        emit(UploadServiceDataError(error: e.toString()));
      }
    });
  }
}
