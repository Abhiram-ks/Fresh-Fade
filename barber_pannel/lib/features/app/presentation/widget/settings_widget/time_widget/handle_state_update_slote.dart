import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/modify_slots_generate_bloc/modify_slots_generate_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/themes/app_colors.dart';

void handleSlotUpdatesState(BuildContext context, ModifySlotsGenerateState state) {
  

    //! Handles the state session for slot deletion
  if (state is ShowDeleteSlotAlert ) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Session Confirmation!',
      message: 'Are you sure you want to permanently delete the session on ${state.date} at ${state.time}?',
      firstButtonText: 'Allow',
      onTap: () {
        context.read<ModifySlotsGenerateBloc>().add(ConfirmDeleteGeneratedSlotEvent());
      },
      firstButtonColor: AppPalette.redColor,
      secondButtonText: "Don't allow",
    );
  } else if (state is DeleteSlotLoading) {
    CustomSnackBar.show(context, message: "Please wait while.", textAlign: TextAlign.center);
  } else if (state is DeleteSlotSuccess) {
    Navigator.pop(context);
    CustomSnackBar.show(context, message: " successfully!", textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);
    } else if (state is DeleteSlotFailure) {
      CustomSnackBar.show(context, message: state.errorMessage, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
  //! Handles the state session for slot Update
  else if(state is SlotStatusChangeFailure) {
     Navigator.pop(context);
    CustomSnackBar.show(context, message: state.errorMessage, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
}
