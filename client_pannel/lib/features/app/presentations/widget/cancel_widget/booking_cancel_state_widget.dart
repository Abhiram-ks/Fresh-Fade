
import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/cancel_booking_bloc/cancel_booking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';

void handleCancelBookingState( BuildContext context, CancelBookingState state, BookingEntity booking){
  final buttonCubit = context.read<ProgresserCubit>();

  if (state is BookingOTPMachingfalse) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: 'Oops! The entered OTP does Code match the booking Code. Please try again carefully.', backgroundColor: AppPalette.blackColor, textAlign: TextAlign.center);
  } else if (state is BookingOTPMachingTrue){
    context.read<CancelBookingBloc>().add(BookingCancelOTPChecked(booking: booking));
  } else if (state is BookingOTPMachingFailure){
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.error , backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  } else if (state is BookingCancelCompleted){
    buttonCubit.stopLoading();
    Navigator.pop(context);
  } else if (state is BookingOTPMachingLoading){
    buttonCubit.startLoading();
  }
}
