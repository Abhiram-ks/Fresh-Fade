import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entity/admin_service_entity.dart';
import '../../../../../domain/usecase/get_admin_services_usecase.dart';

part 'fetch_admin_service_event.dart';
part 'fetch_admin_service_state.dart';

class FetchAdminServiceBloc extends Bloc<FetchAdminServiceEvent, FetchAdminServiceState> {
  final GetAdminServicesUseCase getAdminServicesUseCase;

  FetchAdminServiceBloc({required this.getAdminServicesUseCase}) 
      : super(FetchAdminServiceInitial()) {
    on<FetchAdminServiceRequested>(_onFetchAdminServiceRequested);
  }

  Future<void> _onFetchAdminServiceRequested(
    FetchAdminServiceRequested event,
    Emitter<FetchAdminServiceState> emit,
  ) async {
    emit(FetchAdminServiceLoading());

    await emit.forEach<List<AdminServiceEntity>>(
      getAdminServicesUseCase(),
      onData: (services) {
        if (services.isEmpty) {
          return FetchAdminServiceEmpty();
        } else {
          return FetchAdminServiceSuccess(services: services);
        }
      },
      onError: (error, stackTrace) {
        return FetchAdminServiceError(error: error.toString());
      },
    );
  }
}
