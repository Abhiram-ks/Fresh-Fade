import 'dart:io';

import 'package:barber_pannel/features/app/domain/usecase/update_barber_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final CloudinaryService cloudinaryService;
  final AuthLocalDatasource localDB;
  final UpdateBarberUseCase updateBarberUseCase;

  String barberName = '';
  String ventureName = '';
  String phoneNumber = '';
  String address = '';
  String image = '';
  int age = 0;
  bool hasNewImage = false;

  UpdateProfileBloc({
    required this.cloudinaryService,
    required this.localDB,
    required this.updateBarberUseCase,
  }) : super(UpdateProfileInitial()) {
    on<UpdateProfileRequest>((event, emit) {
      if (event.barberName.isEmpty &&
          event.ventureName.isEmpty &&
          event.phoneNumber.isEmpty &&
          event.address.isEmpty &&
          event.image.isEmpty &&
          event.year <= 0) {
        emit(UpdateProfileError(message: 'No data provided for update'));
        return;
      }

      barberName = event.barberName;
      ventureName = event.ventureName;
      phoneNumber = event.phoneNumber;
      address = event.address;
      image = event.image;
      age = event.year;
      hasNewImage = event.hasNewImage;

      emit(UpdateProfileAlertBox());
    });

    on<ConfirmUpdateRequest>((event, emit) async {
      emit(UpdateProfileLoading());

      try {
        final barberId = await localDB.get();
        if (barberId == null || barberId.isEmpty) {
          emit(UpdateProfileError(message: 'Barber ID not found. Please login again.'));
          return;
        }

        String? imageUrl;

        if (hasNewImage && image.isNotEmpty) {
          if (!image.startsWith('http')) {
            final uploadedUrl = await cloudinaryService.uploadImage(File(image));
            if (uploadedUrl == null) {
              emit(UpdateProfileError(message: 'Failed to upload profile image'));
              return;
            }
            imageUrl = uploadedUrl;
          } else {
            imageUrl = image;
          }
        } else if (image.isNotEmpty) {
          imageUrl = image;
        }

        final bool success = await updateBarberUseCase(
          uid: barberId,
          barberName: barberName.isNotEmpty ? barberName : null,
          ventureName: ventureName.isNotEmpty ? ventureName : null,
          phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
          address: address.isNotEmpty ? address : null,
          image: imageUrl,
          age: age > 0 ? age : null,
        );

        if (success) {
          emit(UpdateProfileSuccess());
        } else {
          emit(UpdateProfileError(message: 'Failed to update profile'));
        }
      } on Exception catch (e) {
        emit(UpdateProfileError(message: e.toString()));
      } catch (e) {
        emit(UpdateProfileError(message: 'An unexpected error occurred: ${e.toString()}'));
      }
    });


  }
}
