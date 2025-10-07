
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';

class CustomCupertinoDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onTap,
    Color? firstButtonColor = AppPalette.redColor,
    Color? secondButtonColor = AppPalette.blackColor,
    required String firstButtonText,
    required String secondButtonText,
  }) {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  firstButtonText,
                  style: TextStyle(color: firstButtonColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onTap(); // Reusable callback
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  secondButtonText,
                  style: TextStyle(color: secondButtonColor),
                ),
              ),
            ],
          ),
    );
  }
}