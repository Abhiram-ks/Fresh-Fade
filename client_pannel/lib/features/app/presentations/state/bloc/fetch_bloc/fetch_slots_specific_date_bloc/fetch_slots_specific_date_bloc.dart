import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/usecase/get_slots_datas_usecase.dart';
part 'fetch_slots_specific_date_event.dart';
part 'fetch_slots_specific_date_state.dart';

class FetchSlotsSpecificDateBloc extends Bloc<FetchSlotsSpecificDateEvent, FetchSlotsSpecificDateState> {
  final GetSlotsDatasUsecase getSlotsDatasUsecase;

  FetchSlotsSpecificDateBloc({required this.getSlotsDatasUsecase}) : super(FetchSlotsSpecificDateInitial()) {
    on<FetchSlotSpecificDateRequested>((event, emit) async {
      emit(FetchSlotsSpecificDateLoading());
      
      try {
        await emit.forEach(
           getSlotsDatasUsecase.execute(barberId: event.barberId, time: event.selectedDate),
           onData: (slots) {
            if (slots.isEmpty) {
              return FetchSlotsSpecificDateEmpty(selectedDate: event.selectedDate);
            } else {
              return FetchSlotsSpecificDateSuccess(slots: slots);
            }
           },
           onError: (error, __) => FetchSlotsSpecificDateFailure(error: error.toString()),
          );
      } catch (e) {
        emit(FetchSlotsSpecificDateFailure(error: e.toString()));
      }
    });
  }
}
