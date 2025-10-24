import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/themes/app_colors.dart';
import '../../../../../auth/presentation/state/cubit/delete_post_cubit/delete_post_cubit.dart';

void handleDeletePostsState(BuildContext context, DeletePostState state) {
  //! Handles the state session for slot deletion
  if (state is DeletePostLoading) {
    CustomSnackBar.show(context, message: "while we delete the post...", textAlign: TextAlign.center, backgroundColor: AppPalette.blackColor);
  } else if (state is DeletePostSuccess) {
    CustomSnackBar.show(context, message: 'Post deleted successfully', textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);

    // Refresh the posts list after successful deletion
    context.read<FetchPostsBloc>().add(FetchPostsRequest());
  } else if (state is DeletePostErorr) {
    CustomSnackBar.show(context, message: state.error, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
}
