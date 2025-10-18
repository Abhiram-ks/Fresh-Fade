part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileEvent {}

final class UpdateProfileRequestEvent extends UpdateProfileEvent {
  final String name;
  final String phone;
  final String address;
  final int age;
  final String photoUrl;
  UpdateProfileRequestEvent({required this.name, required this.phone, required this.address, required this.age, required this.photoUrl});
}

final class UpdateProfileConfirmEvent extends UpdateProfileEvent {}