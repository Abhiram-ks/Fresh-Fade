
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/domain/usecase/update_user_usecase.dart';
import 'package:client_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/data/datasource/auth_local_datasource.dart';
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final CloudinaryService cloud;
  final UpdateUserUseCase usecase;
  final AuthLocalDatasource localDB;
  
  String name = '';
  String phone = '';
  String address = '';
  int age = 0;
  String photoUrl = '';

  UpdateProfileBloc({required this.cloud, required this.usecase, required this.localDB}) : super(UpdateProfileInitial()) {
    on<UpdateProfileRequestEvent>(_onUpdateProfileRequestEvent);
    on<UpdateProfileConfirmEvent>(_onUpdateProfileConfirmEvent);
  }

  void _onUpdateProfileRequestEvent(UpdateProfileRequestEvent event, Emitter<UpdateProfileState> emit) {
    name = event.name;
    phone = event.phone;
    address = event.address;
    age = event.age;
    photoUrl = event.photoUrl;
    emit(UpdateProfileAlertBox());
  }

  Future<void> _onUpdateProfileConfirmEvent(UpdateProfileConfirmEvent event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoading());
    try {

      String image = photoUrl;
       // image upload to cloudinary
      if (image.isEmpty) {
        image = '';
      } else if(!image.startsWith('http')) {
        final String? response = await cloud.uploadImage(File(image));
        if(response == null){
          emit(UpdateProfileError(error: 'Failed to upload image'));
          return;
        }
        image = response;
      }
        
      // Get user uid from local database

      final String? uid = await localDB.get();
      if(uid == null || uid.isEmpty){
        emit(UpdateProfileError(error: 'Token expired. Please login again.'));
        return;
      }
      final result = await usecase.call(uid: uid, name: name,phone: phone, address: address, age: age, photoUrl: image);

      if(result){
        emit(UpdateProfileSuccess());
      } else {
        emit(UpdateProfileError(error: 'Failed to update profile due to Exception'));
      }
    } catch (e) {
      emit(UpdateProfileError(error: e.toString()));
    }
  }
}
