part of 'fetch_service_bloc.dart';

@immutable
abstract class FetchServiceState {}

final class FetchServiceInitial extends FetchServiceState {}

final class FetchServiceLoading extends FetchServiceState {}

final class FetchServiceEmpty extends FetchServiceState {}

final class FetchServiceLoaded extends FetchServiceState {
  final List<ServiceEntity> service;
  FetchServiceLoaded({required this.service});
}

final class FetchServiceError extends FetchServiceState {
  final String message;
  FetchServiceError({required this.message});
}