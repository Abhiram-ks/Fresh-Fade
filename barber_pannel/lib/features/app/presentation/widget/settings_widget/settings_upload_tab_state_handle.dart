import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/app_colors.dart';

void handleUploadPostState(BuildContext context, UploadPostState state, final TextEditingController controller) {
  final button = context.read<ProgresserCubit>();
  
  if (state is UploadPostAlert) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: Text(
          'Session Expiration Confirmation!',
        ),
        message: Text(
                "Are you sure you want to upload this post? This will upload your post and show it to the users.",
              ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
             context.read<UploadPostBloc>().add(UploadPostConfirmEvent());
            },
            isDefaultAction: true,
            child: Text(
              'Yes, Upload',
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
            'May be Later',
            style: TextStyle(
              color: AppPalette.blackColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  } else if (state is UploadPostLoading) {
    button.startLoading();
  }
   else if (state is UploadPostSuccess) {
     context.read<ImagePickerBloc>().add(ClearImageAction());
     controller.clear();
     button.stopLoading();

     CustomSnackBar.show(context, message: 'Uploaded Successful', backgroundColor: AppPalette.greenColor, textAlign: TextAlign.center);

  } else if (state is UploadPostError) {
      button.stopLoading();
    CustomSnackBar.show(context, message: state.error, backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}
