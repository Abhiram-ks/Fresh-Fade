import 'package:barber_pannel/features/app/domain/usecase/get_barber_service_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_service_entity.dart';

part 'fetch_barber_service_event.dart';
part 'fetch_barber_service_state.dart';

class FetchBarberServiceBloc extends Bloc<FetchBarberServiceEvent, FetchBarberServiceState> {
  final GetBarberServiceUsecase usecase;
  final AuthLocalDatasource localDB;
  FetchBarberServiceBloc({required this.usecase, required this.localDB}) : super(FetchBarberServiceInitial()) {
    on<FetchBarberServiceRequestEvent>((event, emit) async {
      emit(FetchBarberServiceLoading());
      try {
        final String? barberID = await localDB.get();
        if (barberID == null) {
          emit(FetchBarberServiceFailure(message: 'Barber ID not found'));
          return;
        }
        await emit.forEach<List<BarberServiceEntity>>(
          usecase(barberID),
          onData: (services) {
            return FetchBarberServiceLoaded(barberServices: services);
          },
          onError: (error, stackTrace) {
            return FetchBarberServiceFailure(message: error.toString());
          },
        );
      } catch (e) {
        emit(FetchBarberServiceFailure(message: e.toString()));
      }
    });
  }
}
