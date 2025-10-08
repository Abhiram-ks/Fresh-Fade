import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/custom_dialogbox.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/routes/routes.dart';
import '../../state/bloc/logout_bloc/logout_bloc.dart';

void handleLogoutState(BuildContext context, LogoutState state) {
  if (state is ShowLogoutDialogState) {
    CustomCupertinoDialog.show(
      context: context,
      title: "Session Expiration Warning!",
      message: "Are you sure you want to logout? This will remove your session and log you out.",
      firstButtonText: 'Yes, Log Out',
      onTap: () {
        BlocProvider.of<LogoutBloc>(context).add(ConfirmLogoutEvent());
        Navigator.pop(context); 
      },
      secondButtonText: 'No, Cancel',
    );
  } else if (state is LogoutSuccessState) {
    Navigator.pushNamedAndRemoveUntil( context, AppRoutes.login, (route) => false);
  } else if (state is LogoutFailureState) {
    CustomSnackBar.show(
      context,
      message: 'Logout Request Failed',
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  }
}
