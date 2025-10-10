import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecase/update_barber_status_usecase.dart';
part 'blocandunbloc_event.dart';
part 'blocandunbloc_state.dart';

class BlocandunblocBloc extends Bloc<BlocandunblocEvent, BlocandunblocState> {
  final UpdateBarberStatusUsecase usecase;
  String _uid = '';
  String _ventureName = '';
  String _name = '';

  String get id => _uid;
  String get ventureName => _ventureName;
  String get name => _name;

  BlocandunblocBloc({required this.usecase}) : super(BlocandunblocInitial()) {
    //! Bloc functionaly 
    on<ShowBlocAlertEvent>((event, emit) {
      _uid = event.uid;
      _ventureName = event.ventureName;
      _name = event.name;

      emit(BlocShowBlocAlertState(name: _name, ventureName: _ventureName));
    });
    

    on<BlocConfirmationEvent>((event, emit) async {
       try {
        final response = await usecase.updateBlocAndUnBloc(uid: _uid, val: true);
        if (response) {
          emit(BlocSuccessState());
        }else {
          emit(BlocErrorState(error: 'Failed to update bloc status'));
        }
       } catch (e) {
         emit(BlocErrorState(error: 'Failed to update bloc status $e'));
       }
    });

    //! Unbloc functionaly 
    on<ShowUnBlacAlertEvent>((event, emit) {
      _uid = event.uid;
      _name = event.name;
      _ventureName = event.ventureName;

      emit(BlocShowUnblocAlertState(name: _name, ventureName: _ventureName));
    });

    on<UnBlocConfirmationEvent>((event, emit) async {
       try {
        final response = await usecase.updateBlocAndUnBloc(uid: _uid, val: false);
        if (response) {
          emit(BlocSuccessState());
        }else {
          emit(BlocErrorState(error: 'Failed to update unbloc status'));
        }
       } catch (e) {
         emit(BlocErrorState(error: 'Failed to update unbloc status $e'));
       }
    });
  }  
}
