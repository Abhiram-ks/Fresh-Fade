
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/admin_request_widget/admin_requst_widget.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

void handleLoginState(BuildContext context, LoginState state) {
  final button = context.read<ProgresserCubit>();

  if (state is LoginLoading) {
    button.startLoading();
  } else if (state is LoginSuccess) {
    button.stopLoading();
    Navigator.pushReplacementNamed(context, AppRoutes.nav);
  } else if (state is LoginEmailNotVarify) {
    button.stopLoading();
    CustomCupertinoDialog.show(
      context: context,
      title: 'Email Not Verified',
      message: 'Please verify your email. Check your ${state.email} inbox or spam folder for the verification link. If you don\'t see it, request a new verification link.',
      onTap: () {
        launchUrl(Uri.parse('mailto:'));
      },
      firstButtonText: 'mailto:',
      secondButtonText: 'Cancel',
      firstButtonColor: AppPalette.buttonColor,
    );
  } else if (state is LoginNotVerified) {
    button.stopLoading();
    navigateToAdminRequest(context);
  } else if (state is LoginBlocShop) {
    button.stopLoading();
    CustomCupertinoDialog.show(
      context: context,
      title: 'Account Has Been Suspended',
      message: 'Unauthorized activity detected on your account while your request was in progress. Please contact support.',
      onTap: () {
        launchUrl(Uri.parse('mailto:freshfade.growblic@gmail.com'));
      },
      firstButtonText: 'Support:',
      secondButtonText: 'Cancel',
      firstButtonColor: AppPalette.buttonColor,
    );
  } else if (state is LoginFailure) {
    button.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.error,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  }
}

