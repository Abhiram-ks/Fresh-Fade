part of 'logout_bloc.dart';

@immutable
abstract class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutAlertState extends LogoutState {}

final class LogoutSuccessState extends LogoutState {}
final class LogoutErrorState extends LogoutState {
  final String error;
  LogoutErrorState({required this.error});
}