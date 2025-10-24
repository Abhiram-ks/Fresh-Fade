import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleSendMessage(BuildContext context, SendMessageState state,TextEditingController controller) {
   final buttonCubit = context.read<ProgresserCubit>();
   if (state is SendMessageLoading) {
     buttonCubit.sendButtonStart();
   }
  else if(state is SendMessageSuccess) {
     controller.clear();
     context.read<ImagePickerBloc>().add(ClearImageAction());
     buttonCubit.stopLoading();
  } else if (state is SendMessageFailure) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(
      context,
      message: 'Message Not Delivered!  ',
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center
    );
  }
}