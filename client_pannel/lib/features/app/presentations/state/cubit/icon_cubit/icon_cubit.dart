import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/themes/app_colors.dart';
part 'icon_state.dart';

class IconCubit extends Cubit<IconState> {
  IconCubit() : super(IconInitial());
   

    void updateIcon(bool isMaxLength,){
    emit(
      ColorUpdated(
        color: isMaxLength ? AppPalette.buttonColor : AppPalette.hintColor,)
    );
  }

  void togglePasswordVisibility(bool isVisible){
    emit(PasswordVisibilityUpdated(isVisible: !isVisible));
  }
} 
