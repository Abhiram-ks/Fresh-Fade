import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/generate_slots_bloc/generate_slot_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleSlotUploadState(BuildContext context, GenerateSlotState state) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is GenerateSlotAlertState ) {
    // Capture the parent context before showing the dialog
    final parentContext = context;
    showCupertinoModalPopup(
    context: context,
    builder: (BuildContext dialogContext) => CupertinoActionSheet(
      title: Text('Session Confirmation!'),
      message: Text(
        'That slot geneattion relected delails carefuly read befor proceding. That geneater slot will be availbel fo rclinet. \n\n'
          'You have selected ${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year}.\n'
          'Session Time: ${state.startTime.format(dialogContext)} to ${state.endTime.format(dialogContext)}\n'
          'Duration: ${state.duration}\n\n'
          'Do you want to confirm this session?', textAlign: TextAlign.center),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            parentContext.read<GenerateSlotBloc>().add(SlotGenerateConfirmation());
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
          isDefaultAction: true,
          child: Text('Allow',style: TextStyle(color: AppPalette.buttonColor, fontSize: 14),),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          isDestructiveAction: true,
          child: Text('Maybe Later',style: TextStyle(color: AppPalette.blackColor, fontSize: 14),),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(dialogContext);
        },
        child: Text('Cancel',style: TextStyle(color: AppPalette.blackColor, fontSize: 14),),
      ),
    ),
  );
  } else if (state is GenerateSlotLoading) {
    buttonCubit.startLoading();
  } else if (state is GenerateSlotGenerated && context.findAncestorStateOfType<State>()?.mounted == true) {
    buttonCubit.stopLoading();
     CustomSnackBar.show(context, message: 'Session Successful!',backgroundColor: AppPalette.greenColor, textAlign: TextAlign.center);

  } else if (state is GenerateSLotFailure && context.findAncestorStateOfType<State>()?.mounted == true) {
    buttonCubit.stopLoading();
         CustomSnackBar.show(context, message: state.errorMessage,backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}
