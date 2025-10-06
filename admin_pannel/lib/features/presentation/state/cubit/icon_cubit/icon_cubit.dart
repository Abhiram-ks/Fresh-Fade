import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'icon_state.dart';

class IconCubit extends Cubit<IconState> {
  IconCubit() : super(IconInitial());

  void togglePasswordVisibility(bool isVisible){
    emit(PasswordVisibilityUpdated(isVisible: !isVisible));
  }
} 
