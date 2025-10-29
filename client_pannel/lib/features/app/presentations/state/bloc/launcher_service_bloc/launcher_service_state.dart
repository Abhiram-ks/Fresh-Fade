part of 'launcher_service_bloc.dart';

@immutable
abstract class LauncherServiceState {}

final class LauncherServiceInitial extends LauncherServiceState {}

final class LauncherServiceAlertBox extends LauncherServiceState {}

final class LauncherServiceLoading extends LauncherServiceState {}

final class LauncherServiceSuccess extends LauncherServiceState {}

final class LauncherServiceFailure extends LauncherServiceState {
  final String error;
  LauncherServiceFailure({required this.error});
}