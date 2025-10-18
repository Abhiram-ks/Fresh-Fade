part of 'fetch_admin_service_bloc.dart';

@immutable
abstract class FetchAdminServiceState {}

final class FetchAdminServiceInitial extends FetchAdminServiceState {}

final class FetchAdminServiceLoading extends FetchAdminServiceState {}
final class FetchAdminServiceSuccess extends FetchAdminServiceState {
  final List<Service> services;
  FetchAdminServiceSuccess({required this.services});
}
final class FetchAdminServiceError extends FetchAdminServiceState {
  final String error;
  FetchAdminServiceError({required this.error});
}