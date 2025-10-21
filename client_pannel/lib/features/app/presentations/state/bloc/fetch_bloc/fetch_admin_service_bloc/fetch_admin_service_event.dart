part of 'fetch_admin_service_bloc.dart';

@immutable
abstract class FetchAdminServiceEvent {}
final class FetchAdminServiceRequested extends FetchAdminServiceEvent {}