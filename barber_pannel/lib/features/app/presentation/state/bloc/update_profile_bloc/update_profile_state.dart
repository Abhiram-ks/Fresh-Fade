part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileAlertBox extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}
final class UpdateProfileSuccess extends UpdateProfileState {}
final class UpdateProfileError extends UpdateProfileState {
  final String message;
  
  UpdateProfileError({required this.message});
}