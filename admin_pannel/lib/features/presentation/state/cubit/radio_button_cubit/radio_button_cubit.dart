import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'radio_button_state.dart';

class RadioCubit extends Cubit<RadioState> {
  RadioCubit() : super(RadioInitial());

  void selectOption(String option){
    emit(RadioSelected(selectedOption: option));
  }
}
