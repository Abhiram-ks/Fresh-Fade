import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_service_entity.dart';
import '../../../../../domain/usecase/get_barber_services_usecase.dart';
part 'fetch_barber_service_event.dart';
part 'fetch_barber_service_state.dart';

class FetchBarberServiceBloc extends Bloc<FetchBarberServiceEvent, FetchBarberServiceState> {
  final GetBarberServicesUseCase getBarberServicesUseCase;

  FetchBarberServiceBloc({required this.getBarberServicesUseCase}) : super(FetchBarberServiceInitial()) {
    on<FetchBarberServiceRequest>((event, emit) async {
       emit(FetchBarberServiceLoading());
       try {
        await emit.forEach(
          getBarberServicesUseCase.call(event.barberId),
          onData: (services) {
            if (services.isEmpty) {
              return FetchBarberServiceEmpty();
            } else {
              return FetchBarberServiceSuccess(services: services);
            }
          },
          onError: (error, stackTrace) => FetchBarberServiceFailure(error: error.toString()),
        );
       } catch (e) {
        emit(FetchBarberServiceFailure(error: e.toString()));
       }
    });
  }
}
