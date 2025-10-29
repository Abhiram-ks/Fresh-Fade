import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/model/data_model.dart';
import '../../../../../domain/usecase/get_slots_datas_usecase.dart';

part 'fetch_slots_dates_event.dart';
part 'fetch_slots_dates_state.dart';

class FetchSlotsDatesBloc extends Bloc<FetchSlotsDatesEvent, FetchSlotsDatesState> {
  final GetSlotsDatasUsecase getSlotsDatasUsecase;

  FetchSlotsDatesBloc({required this.getSlotsDatasUsecase}) : super(FetchSlotsDatesInitial()) {
    on<FetchSlotsDatesRequested>((event, emit) async{
      emit (FetchSlotsDatesLoading());

      try {
        await getSlotsDatasUsecase.call(barberId: event.barberId).forEach((datas) {
          emit(FetchSlotsDatesSuccess(dates: datas));
        });
      } catch (e) {
        emit(FetchSlotsDatesFailure(error: e.toString()));
      }
    });
  }
}
