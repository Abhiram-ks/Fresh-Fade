
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/launcher_service_bloc/launcher_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_cupertino_dialog.dart';
import '../../../../../core/common/custom_snackbar.dart';

void handleEmailLaucher(BuildContext context, LauncherServiceState state) {
  if (state is LauncherServiceAlertBox) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Please confirm the session',
      message:
          'Are you sure you want to launch the email? Yes? confirm else declired that activity',
      onTap: () {
        context.read<LauncherServiceBloc>().add(LauncherServiceConfirmEvent());
      },
      firstButtonColor: AppPalette.buttonColor,
      firstButtonText: 'Confirm',
      secondButtonText: 'Decline',
      secondButtonColor: AppPalette.blackColor,
    );
  } else if (state is LauncherServiceSuccess) {
    CustomSnackBar.show(
      context,
      message: 'Email launched successfully',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.greenColor,
    );
  } else if (state is LauncherServiceFailure) {
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  } else if (state is LauncherServiceLoading) {
    CustomSnackBar.show(
      context,
      message: 'Email launching in progress.',
      textAlign: TextAlign.center,
    );
  }
}
