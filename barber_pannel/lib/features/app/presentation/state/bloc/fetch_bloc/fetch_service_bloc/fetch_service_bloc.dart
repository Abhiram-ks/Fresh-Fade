import 'package:barber_pannel/features/app/domain/entity/service_entity.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_services_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'fetch_service_event.dart';
part 'fetch_service_state.dart';

class FetchServiceBloc extends Bloc<FetchServiceEvent, FetchServiceState> {
  final GetServicesUseCase useCase;

  FetchServiceBloc({required this.useCase}) : super(FetchServiceInitial()) {
    on<FetchServiceRequest>(_onFetchAllService);
  }

  Future<void> _onFetchAllService(
    FetchServiceRequest event,
    Emitter<FetchServiceState> emit,
  ) async {
    emit(FetchServiceLoading());
    
    try {
      await emit.forEach<List<ServiceEntity>>(
        useCase(),
        onData: (services) {
          if (services.isEmpty) {
            return FetchServiceEmpty();
          }
          return FetchServiceLoaded(service: services);
        },
        onError: (error, stackTrace) {
          final errorMessage = error.toString().replaceFirst('Exception: ', '');
          return FetchServiceError(message: errorMessage);
        },
      );
    } catch (e) {
      emit(FetchServiceError(message: 'Failed to load services: ${e.toString()}'));
    }
  }
}
