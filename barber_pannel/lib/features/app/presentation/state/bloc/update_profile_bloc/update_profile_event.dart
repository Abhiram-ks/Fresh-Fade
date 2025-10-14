part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileEvent {}

final class UpdateProfileRequest extends UpdateProfileEvent {
  final String image;
  final String barberName;
  final String ventureName;
  final String phoneNumber;
  final String address;
  final int year;
  final bool hasNewImage;

  UpdateProfileRequest({
    this.image = '',
    this.barberName = '',
    this.ventureName = '',
    this.phoneNumber = '',
    this.address = '',
    this.year = 0,
    this.hasNewImage = false,
  });
}

final class ConfirmUpdateRequest extends UpdateProfileEvent {}
