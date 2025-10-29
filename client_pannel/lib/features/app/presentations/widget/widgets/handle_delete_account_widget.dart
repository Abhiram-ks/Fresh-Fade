import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleDeleteAccountState(BuildContext context, DeleteAccountState state) {
  if (state is DeleteAccountAlertBox) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text('Delete Account?'),
            content: Text(
              'Are you sure you want to delete your account? This action is permanent and requires verification before proceeding to the next step.',
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Proceed ',
                  style: TextStyle(color: AppPalette.redColor),
                ),
                onPressed: () {
                    Navigator.pop(context);
                   context.read<DeleteAccountBloc>().add(DeleteAccountConfirmEvent());
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppPalette.blackColor),
                ),
              ),
            ],
          ),
    );
  } else if (state is DeleteAccountSuccess) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  } else if (state is DeleteAccountFailure) {
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  } else if (state is DeleteAccountLoading) {
    CustomSnackBar.show(
      context,
      message: 'Deleting account in progress.',
      textAlign: TextAlign.center,
    );
  }
}
