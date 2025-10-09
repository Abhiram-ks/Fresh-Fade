import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/bloc/admin_request_widget/admin_requst_widget.dart';

void handleRegisterState(BuildContext context, RegisterState state) {
  final buttonCubit = context.read<ProgresserCubit>();

  if (state is RegisterAlertBoxState) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Registration Confirmation',
      message:'Please verify your details:\n\nName: ${state.name}\nVenture: ${state.venturename}\nEmail: ${state.email}\n\nYou will undergo a verification process after registration.',
      onTap: () {
        context.read<RegisterBloc>().add(RegisterSubmit());
      },
      firstButtonText: 'Confirm & Register',
      secondButtonText: 'Cancel',
      firstButtonColor: AppPalette.buttonColor,
    );
  } else if (state is RegisterLoading) {
    buttonCubit.startLoading();
  } else if (state is RegisterSuccess) {
    buttonCubit.stopLoading();
    navigateToAdminRequest(context);
  } else if (state is RegisterFailure) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.error,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  }
}
