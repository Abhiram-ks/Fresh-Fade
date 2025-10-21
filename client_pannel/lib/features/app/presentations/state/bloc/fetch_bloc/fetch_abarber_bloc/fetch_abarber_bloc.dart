import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_entity.dart';

part 'fetch_abarber_event.dart';
part 'fetch_abarber_state.dart';

class FetchAbarberBloc extends Bloc<FetchAbarberEvent, FetchAbarberState> {
  final GetBarberUseCase usecase;

  FetchAbarberBloc({required this.usecase}) : super(FetchAbarberInitial()) {
    on<FetchABarberEventRequest>((event, emit) async{
      emit(FetchAbarberLoading());
      
      try {
       await emit.forEach(
        usecase.call(event.barberId), 
        onData: (barber) => FetchABarberSuccess(barber: barber),
        onError: (error, stackTrace) => FetchABarberError(message: error.toString()),
      );
      } catch (e) {
        emit(FetchABarberError(message: e.toString()));
      }
    });
  }
}
