  import 'package:barber_pannel/core/common/custom_snackbar.dart';
  import 'package:barber_pannel/features/app/presentation/state/bloc/upload_service_data_bloc.dart/upload_service_data_bloc.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  import '../../../../../core/themes/app_colors.dart';
  import '../../../../auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';

  void handleServiceWidgetState (BuildContext context, UploadServiceDataState state) {
    final button = context.read<ProgresserCubit>();
    final uploadBloc = context.read<UploadServiceDataBloc>();


  if (state is UploadServiceDataDialogBox) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Section Confirmation',
        ),
        message: Text(
         'Are you sure you want to proceed? The details will be updated. This action will overwrite or update existing data. Your changes to ${state.gender} and the image will also be updated.',
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              
              uploadBloc.add(UploadServiceDataConfirmation());
            },
            child:  Text('Confirm', style: TextStyle(fontSize: 15, color: AppPalette.buttonColor),),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('May be later', style: TextStyle(fontSize: 15,color: AppPalette.blackColor),),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel',style: TextStyle(fontSize: 15,color: AppPalette.blackColor),),
        ),
      ),
    );
  }else if (state is UploadServiceDataLoading) {
      button.startLoading();
    } else if (state is UploadServiceDataSuccess) {
      button.stopLoading();
      CustomSnackBar.show(context, message: 'Uploaded Successfully!', textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);
    } else if (state is UploadServiceDataError) {
      button.stopLoading();
      CustomSnackBar.show(context, message: state.error, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
    }
  }