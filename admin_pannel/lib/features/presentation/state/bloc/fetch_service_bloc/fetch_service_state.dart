part of 'fetch_service_bloc.dart';

@immutable
abstract class FetchServiceState  {}

final class FetchingServiceInitial extends FetchServiceState {}

class ServiceLoadingState extends FetchServiceState{}
class ServiceEmptyState extends FetchServiceState{}
class ServiceLoadedState extends FetchServiceState{
  final List<ServiceEntity> services;
  ServiceLoadedState(this.services);
}


class ServiceFechingErrorState extends FetchServiceState {
  final String error;
  ServiceFechingErrorState(this.error);
}

