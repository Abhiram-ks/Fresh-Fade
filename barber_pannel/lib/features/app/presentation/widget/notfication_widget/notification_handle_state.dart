import 'dart:developer';

import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/booking_status_update_bloc/booking_status_update_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleNotifiactionState(
  BuildContext context,
  BookingStatusUpdateState state,
) {
  if (state is BookingStatusUpdateAlertBox) {
    
    CustomCupertinoDialog.show(
      context: context,
      title: 'Session Confirmation',
      message: 'Do you want to overwrite this session and mark it as completed? Please note that this action cannot be undone. Make sure all details are correct before proceeding. Do you want to continue?',

      onTap: () {
          if (state.isAll) {
            context.read<BookingStatusUpdateBloc>().add(BookingStatusUpdatesAllTimeouts());
          } else {
            context.read<BookingStatusUpdateBloc>().add(BookingStatusUpdateConfirmed());
          }
      },
      firstButtonColor: AppPalette.buttonColor,
      firstButtonText: 'Agree',
      secondButtonText: 'Cancel',
    );
  } else if (state is BookingStatusUpdateLoading) {
    CustomSnackBar.show(context, message: 'Updating booking status...', textAlign: TextAlign.center);
  } else if (state is BookingStatusUpdateSuccess) {
    CustomSnackBar.show(context, message: 'Booking status updated successfully...', textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor, durationSeconds: 1);
  } else if (state is BookingStatusUpdateFailure) {
    CustomSnackBar.show(context, message: state.error, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
}
