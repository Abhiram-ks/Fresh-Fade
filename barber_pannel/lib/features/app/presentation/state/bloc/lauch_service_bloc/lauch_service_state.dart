part of 'lauch_service_bloc.dart';

@immutable
abstract class LauchServiceState {}

final class LauchServiceInitial extends LauchServiceState {}
final class LauchServiceAlertBox extends LauchServiceState {}
final class LauchServiceLoading extends LauchServiceState {}
final class LauchServiceAlertBoxSuccess extends LauchServiceState {}
final class LauchServiceAlertBoxError extends LauchServiceState {
  final String error;
  LauchServiceAlertBoxError({required this.error});
}