import 'package:barber_pannel/features/app/presentation/state/cubit/share_cubit/share_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/custom_snackbar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_image.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../data/model/post_with_barber_model.dart';
import '../../state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import '../../state/cubit/like_post_cubit/like_post_cubit.dart';
import 'post_bottom_sheet_widget.dart';
import 'post_card_main_widget.dart';

RefreshIndicator postBlocSuccessStateBuilder({
  required BuildContext context,
  required List<PostWithBarberModel> model,
  required FetchPostWithBarberLoaded state,
  required double screenHeight,
  required double screenWidth,
  required double heightFactor,
  required TextEditingController commentController,
}) {
  return RefreshIndicator(
    color: AppPalette.buttonColor,
    backgroundColor: AppPalette.whiteColor,
    onRefresh: () async {
      context.read<FetchPostWithBarberBloc>().add(
        FetchPostWithBarberRequested(),
      );
    },
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (context, index) {
        final data = model[index];
        final formattedDate = formatDate(data.post.createdAt);
        final formattedStartTime = formatTimeRange(data.post.createdAt);

        return BlocListener<ShareCubit, ShareState>(
          listener: (context, state) {
             handleShareStateCubit(context, state);
          },
          child: PostScreenMainWidget(
            screenHeight: screenHeight,
            heightFactor: heightFactor,
            screenWidth: screenWidth,
            shopName: data.barber.ventureName,
            description: data.post.description,
            isLiked: data.post.likes.contains(data.barber.uid),
            favoriteColor:
                data.post.likes.contains(data.barber.uid)
                    ? AppPalette.redColor
                    : AppPalette.blackColor,
            favoriteIcon:
                data.post.likes.contains(data.barber.uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
            likes: data.post.likes.length,
            location: data.barber.address,
            postUrl: data.post.imageUrl,
            shopUrl: data.barber.image ?? AppImages.appLogo,
            shareOnTap: () {
              context.read<ShareCubit>().sharePost(
                text: data.post.description,
                ventureName: data.barber.ventureName,
                location: data.barber.address,
                imageUrl: data.post.imageUrl,
              );
            },
            commentOnTap: () {
              showCommentSheet(
                context: context,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                barberId: data.barber.uid,
                docId: data.post.postId,
                commentController: commentController,
              );
            },
            likesOnTap: () {
              context.read<LikePostCubit>().likePost(
                barberId: data.barber.uid,
                postId: data.post.postId,
                curretLikes: data.post.likes,
              );
            },
            profilePage: () {},
            dateAndTime: '$formattedDate at $formattedStartTime',
          ),
        );
      },
      separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
    ),
  );
}

//! Date time formatter
String formatTimeRange(DateTime startTime) {
  final String time = DateFormat.jm().format(startTime);
  return time;
}
DateTime convertToDateTime(String dateString) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.parse(dateString);
}


String formatDate(DateTime dateTime) {
  final dateFormat = DateFormat('dd MMM yyyy');
  return dateFormat.format(dateTime);
}


void handleShareStateCubit(BuildContext context,ShareState state){

  if (state is ShareLoading) {
    CustomSnackBar.show(context, message: "Share post lauch. Loading", textAlign: TextAlign.center, backgroundColor: AppPalette.blackColor);
  } else if (state is ShareSuccess) {
    CustomSnackBar.show(context, message: "Share post success", textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);
  } else if (state is ShareFailure) {
    CustomSnackBar.show(context, message: state.error, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
}