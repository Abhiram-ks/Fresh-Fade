import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/request_bloc/request_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service_widget/service_regectionbox.dart';

void requestStateHandle(BuildContext context, RequestState state) {
  if (state is RequestSuccessState) {
    CustomSnackBar.show(
      context,
      message: 'Request Success',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.greenColor,
    );
  } else if (state is AcceptAlertState) {
    // Get the bloc reference before showing the modal
    final requestBloc = context.read<RequestBloc>();
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: Text(
          'Accept Request',
        ),
        message: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Text(
                "Are you sure you want to accept this barber's request? Please verify their details before confirming. Once accepted, their shop will join our community",
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
              requestBloc.add(AcceptConfirmation());
            },
            isDefaultAction: true,
            child: Text(
              'Accept Request',
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
  } else if (state is RejectAlertState) {
    final requestBloc = context.read<RequestBloc>();
      showDialog(
    context: context,
    builder: (BuildContext context) {
      return RejectionAlertbox(
        textIcon: CupertinoIcons.mail_solid,
        label: 'Reason for Rejection',
        hintText: 'Please provide a valid reason for rejection',

        title: "Rejection Confirmation",
        firstButtonText: "Confirm",
        firstButtonAction: (reason) {
            Navigator.pop(context);
            requestBloc.add(RejectConfirmation(reason: reason));
        },
        firstButtonColor: AppPalette.redColor,
        secondButtonText: "Cancel",
        secondButtonAction: () {
          Navigator.pop(context);
        },
        secondButtonColor: AppPalette.blackColor,
      );
    },
  );
  }   else if (state is RequestErrorState) {
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  } 
}

