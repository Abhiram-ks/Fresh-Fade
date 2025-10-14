import 'package:barber_pannel/features/app/domain/usecase/generate_slot_usecase.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/duration_picker/duration_picker_cubit.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart' show AuthLocalDatasource;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../data/datasource/slot_remote_datasource.dart';
part 'generate_slot_event.dart';
part 'generate_slot_state.dart';

class GenerateSlotBloc extends Bloc<GenerateSlotEvent, GenerateSlotState> {
  final SlotRepository slotRepository;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  DurationTime _duration = DurationTime.standard;
  final AuthLocalDatasource localDB;

  GenerateSlotBloc(this.slotRepository, this.localDB) : super(GenerateSlotInitial()) {
    on<SlotGenerateRequest>((event, emit) {
      _selectedDate = event.selectedDate;
      _startTime = event.startTime;
      _endTime = event.endTime;
      _duration = event.duration;
      emit(GenerateSlotAlertState(selectedDate: event.selectedDate, startTime: event.startTime, endTime: event.endTime, duration: event.duration));
    });

    on<SlotGenerateConfirmation>((event, emit) async {
      emit(GenerateSlotLoading());
      try {
        List<Map<String, dynamic>> generatedSlots = SlotGenerator.generateSlots(
          date: _selectedDate, 
          start: _startTime, 
          end: _endTime, 
          duration: _duration);
        
        if(generatedSlots.isEmpty){
          emit(GenerateSLotFailure('No slots generated. Please check your timings'));
          return;
        } 

        final String?  barberUid = await localDB.get();

        if (barberUid == null || barberUid.isEmpty) {
          emit(GenerateSLotFailure('Token Expired. Please Login Again'));
          return;
        }


          bool isSuccess = await slotRepository.uploadSlots(
          barberUid: barberUid,
          selectedDate: _selectedDate,
          duration: _duration,
          slotTime: generatedSlots);


          if (isSuccess) {
            emit(GenerateSlotGenerated());
          }else{
            emit(GenerateSLotFailure('An unexpected error occurred :Slots for Session failure'));
          }
     
      } catch (e) {
        emit(GenerateSLotFailure(e.toString()));
      }
    });
  }
}