part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}
final class RegisterLoading extends RegisterState {}
final class RegisterAlertBoxState extends RegisterState {
  final String name;
  final String venturename;
  final String email;
  RegisterAlertBoxState({required this.name, required this.venturename, required this.email});
}
final class RegisterSuccess extends RegisterState {}
final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}