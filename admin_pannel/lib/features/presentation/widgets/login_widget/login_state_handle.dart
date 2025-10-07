import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/routes/routes.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void loginStateHandle(BuildContext context, LoginState state) {
  final button = context.read<ProgresserCubit>();
  if (state is LoginLoading) {
    button.startLoading();
  } else if (state is LoginSuccess) {
      button.stopLoading();
    Navigator.pushReplacementNamed(context, AppRoutes.dashbord);
  } else if (state is LoginFailure) {
      button.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  }
}
