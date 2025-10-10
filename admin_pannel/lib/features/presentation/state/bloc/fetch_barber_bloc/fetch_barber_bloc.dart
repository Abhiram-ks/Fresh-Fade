import 'package:admin_pannel/features/domain/entity/barber_entity.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_barber_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'fetch_barber_event.dart';
part 'fetch_barber_state.dart';

class FetchBarberBloc extends Bloc<FetchBarberEvent, FetchBarberState> {
  final FetchBarberUsecase fetchBarberUsecase;

  FetchBarberBloc(this.fetchBarberUsecase) : super(FetchBarberInitial()) {
    on<FetchAllBarbersEvent>(_onFetchAllBarbers);
  }

  Future<void> _onFetchAllBarbers(
    FetchAllBarbersEvent event,
    Emitter<FetchBarberState> emit,
  ) async {
    emit(FetchBarberLoading());

    await emit.forEach<List<BarberEntity>>(
      fetchBarberUsecase.execute(),
      onData: (barbers) {
        if (barbers.isEmpty) {
          return FetchBarberEmpty();
        } else {
          return FetchBarberLoaded(barbers);
        }
      },
      onError: (error, stackTrace) {
        return FetchBarberError(error.toString());
      },
    );
  }
}
