import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void handleLogOutState(BuildContext context, LogoutState state) {
  if (state is LogoutAlertState) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: Text(
          'Session Expiration Warning!',
        ),
        message: Text(
                "Are you sure you want to logout? This will remove your session and log you out.",
              ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
              context.read<LogoutBloc>().add(LogoutConfirmEvent());
            },
            isDefaultAction: true,
            child: Text(
              'Yes, Log Out',
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
            'No, Cancel',
            style: TextStyle(
              color: AppPalette.blackColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  } else if (state is LogoutSuccessState) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  } else if (state is LogoutErrorState) {
    CustomSnackBar.show(context, message: state.error, backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}
