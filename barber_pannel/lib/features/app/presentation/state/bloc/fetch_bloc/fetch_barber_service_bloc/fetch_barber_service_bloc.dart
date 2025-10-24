import 'package:barber_pannel/features/app/domain/entity/barber_service_entity.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_services_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'fetch_barber_service_event.dart';
part 'fetch_barber_service_state.dart';

class FetchBarberServiceBloc extends Bloc<FetchBarberServiceEvent, FetchBarberServiceState> {
  final GetBarberServicesUseCase useCase;
  final AuthLocalDatasource localDB;

  FetchBarberServiceBloc({
    required this.useCase,
    required this.localDB,
  }) : super(FetchBarberServiceInitial()) {
    on<FetchBarberServiceRequest>(_onFetchBarberServices);
  }

  Future<void> _onFetchBarberServices(
    FetchBarberServiceRequest event,
    Emitter<FetchBarberServiceState> emit,
  ) async {
    emit(FetchBarberServiceLoading());

    try {
      // Get barber ID from local storage
      final barberId = await localDB.get();
      if (barberId == null || barberId.isEmpty) {
        emit(FetchBarberServiceError(message: 'Barber ID not found. Please login again.'));
        return;
      }

      // Stream services with real-time updates
      await emit.forEach<List<BarberServiceEntity>>(
        useCase(barberId: barberId),
        onData: (services) {
          if (services.isEmpty) {
            return FetchBarberServiceEmpty();
          }
          return FetchBarberServiceLoaded(services: services);
        },
        onError: (error, stackTrace) {
          final errorMessage = error.toString().replaceFirst('Exception: ', '');
          return FetchBarberServiceError(message: errorMessage);
        },
      );
    } catch (e) {
      emit(FetchBarberServiceError(message: 'Failed to load services: ${e.toString()}'));
    }
  }
}

