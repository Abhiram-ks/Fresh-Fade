import 'package:client_pannel/features/app/presentations/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_snackbar.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/send_message_bloc/send_message_bloc.dart';

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
    CustomSnackBar.show(context, message: 'Message Not Delivered! Let’s try again.', backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}