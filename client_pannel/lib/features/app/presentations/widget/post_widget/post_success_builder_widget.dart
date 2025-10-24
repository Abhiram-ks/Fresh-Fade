import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fech_post_with_barber_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../../data/model/post_with_barber_model.dart';
import '../../state/cubit/like_post_cubit/like_post_cubit.dart';
import '../../state/cubit/share_cubit/share_cubit.dart';
import 'post_body_main_widget.dart';
import 'post_comment_widget.dart';

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
      context.read<FechPostWithBarberBloc>().add(FetchPostWithBarberRequest());
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
            isLiked: data.post.likes.contains(state.userId),
            favoriteColor:
                data.post.likes.contains(state.userId)
                    ? AppPalette.redColor
                    : AppPalette.blackColor,
            favoriteIcon:
                data.post.likes.contains(state.userId)
                    ? Icons.favorite
                    : Icons.favorite_border,
            likes: data.post.likes.length,
            location: data.barber.address,
            postUrl: data.post.imageUrl,
            shopUrl: data.barber.image ?? AppImages.barberEmpty,
            chatOnTap: () {
              Navigator.pushNamed(context, AppRoutes.chatWindow, arguments: {
                'barberId': data.barber.uid,
                'userId': state.userId,
              });
            },
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
              context.read<LikePostCubit>().toggleLike(
                barberId: data.barber.uid,
                postId: data.post.postId,
                userId: state.userId,
                currentLikes: data.post.likes,
              );
            },
            profilePage: () {
              if (data.barber.isBloc) {
                CustomSnackBar.show(context, message: 'This shop account has been suspended due to unauthorized activity detected!', backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
              } else {
                Navigator.pushNamed(
                  context,
                  AppRoutes.detailBarber,
                  arguments: data.barber.uid,
                );
              }
            },
            dateAndTime: '$formattedDate at $formattedStartTime',
          ),
        );
      },
      separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
    ),
  );
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