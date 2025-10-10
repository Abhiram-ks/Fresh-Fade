
import 'package:admin_pannel/features/presentation/state/bloc/bloc_and_unbloc_bloc/blocandunbloc_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/themes/app_colors.dart';

void blocUnblocStateHandle(BuildContext context, BlocandunblocState state) {
  if (state is BlocSuccessState) {
    CustomSnackBar.show(
      context,
      message: 'Status Updated Successfully',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.greenColor,
    );
  } else if (state is BlocShowBlocAlertState) {
    // Get the bloc reference before showing the modal
    final requestBloc = context.read<BlocandunblocBloc>();
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: Text(
          'Account Suspend Request',
        ),
        message: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Text(
                "Are you sure you want to suspend this barber's account? Please verify their details before confirming.",
              ),
              ConstantWidgets.hight10(modalContext),
              Text(
                'Name: ${state.name}',
                textAlign: TextAlign.center,
              ),
              Text(
                'Venture: ${state.ventureName}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
              requestBloc.add(BlocConfirmationEvent());
            },
            isDefaultAction: true,
            child: Text(
              'Suspend Account',
              style: TextStyle(
                fontSize: 14,
                color: AppPalette.redColor,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(modalContext);
          },
          isDestructiveAction: true,
          child: Text(
            'May be later',
            style: TextStyle(
              color: AppPalette.blackColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  } else if (state is BlocShowUnblocAlertState) {
    final requestBloc = context.read<BlocandunblocBloc>();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: Text(
          'Account Re-Activate Request',
        ),
        message: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Text(
                "Are you sure you want to re-activate this barber's account? Please verify their details before confirming.",
              ),
              ConstantWidgets.hight10(modalContext),
              Text(
                'Name: ${state.name}',
                textAlign: TextAlign.center,
              ),
              Text(
                'Venture: ${state.ventureName}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
              requestBloc.add(UnBlocConfirmationEvent());
            },
            isDefaultAction: true,
            child: Text(
              'Re-Activate Account',
              style: TextStyle(
                fontSize: 14,
                color: AppPalette.greenColor,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(modalContext);
          },
          isDestructiveAction: true,
          child: Text(
            'May be later',
            style: TextStyle(
              color: AppPalette.blackColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  } else if (state is BlocErrorState) {
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  } 
}

