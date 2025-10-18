import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_snackbar.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/send_comment_bloc/send_comment_bloc.dart';

void handleSendComments(BuildContext context, SendCommentState state,
    TextEditingController controller) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is SendCommentLoading) {
    buttonCubit.sendButtonStart();
  } else if (state is SendCommentSuccess) {
    controller.clear();
    buttonCubit.stopLoading();
  } else if (state is SendCommentFailure) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.error, backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}