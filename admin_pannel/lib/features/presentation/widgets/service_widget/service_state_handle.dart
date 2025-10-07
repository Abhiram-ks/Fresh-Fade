
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/custom_dialogbox.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/themes/app_colors.dart';
import '../../state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'service_regectionbox.dart';

void handSeviceState(BuildContext context, ServiceMangementState state) {
  if (state is UploadServiceSuccessState) {
    CustomSnackBar.show(
      message: 'Service Uploaded Successfully',
      backgroundColor: AppPalette.greenColor,
      context,
      textAlign: TextAlign.center,
    );
  } else if (state is ServiceErrorState) {
    CustomSnackBar.show(
      context,
      message: 'Service Database Connection Error. ${state.error}',
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  } else if (state is ShowDeleteServiceAlert) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Service Deletion Confirmation',
      message:
          "Confirm deletion? This action is irreversible, and the service will be permanently removed from the database.",
      firstButtonText: 'Allow',
      onTap: () {
        context.read<ServiceMangementBloc>().add(DeleteConfirmation());
      },
      secondButtonText: "Don't Allow",
    );
  } else if (state is ShowEditServiceTestFeld) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RejectionAlertbox(
          title: state.currentService,
          firstButtonText: 'Update',
          firstButtonAction: (reason) {
            context.read<ServiceMangementBloc>().add(
              UpdateServiceEvent(reason),
            );
            Navigator.pop(context);
          },
          firstButtonColor: AppPalette.blueColor,
          secondButtonText: 'Cancel',
          secondButtonAction: () => Navigator.pop(context),
          label: 'Update Services',
          secondButtonColor: AppPalette.blackColor,
          textIcon: CupertinoIcons.pencil,
          hintText: 'Please Enter Service',
          initialReason: state.currentService,
        );
      },
    );
  }
}