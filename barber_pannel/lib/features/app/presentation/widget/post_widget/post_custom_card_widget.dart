
import 'package:barber_pannel/features/app/presentation/state/cubit/post_like_animation_cubit/post_like_animation_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_image.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../screens/setting/setting_screen.dart';

class PostgScreenGenerateWIdget extends StatelessWidget {
  const PostgScreenGenerateWIdget({
    super.key,
    required this.profilePage,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.isLiked,
    required this.likesOnTap,
    required this.screenHeight,
    required this.heightFactor,
    required this.postUrl,
    required this.favoriteIcon,
    required this.favoriteColor,
    required this.shareOnTap,
    required this.commentOnTap,
    required this.screenWidth,
    required this.likes,
    required this.description,
    required this.dateAndTime,
  });

  final VoidCallback profilePage;
  final String shopUrl;
  final String shopName;
  final String location;
  final VoidCallback likesOnTap;
  final double screenHeight;
  final double heightFactor;
  final String postUrl;
  final IconData favoriteIcon;
  final Color favoriteColor;
  final VoidCallback shareOnTap;
  final VoidCallback commentOnTap;
  final double screenWidth;
  final int likes;
  final String description;
  final String dateAndTime;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstantWidgets.hight10(context),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: profilePage,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: ClipOval(
                        child: Container(
                            color: Colors.grey.shade800,
                            child: (shopUrl.startsWith('http'))
                                ? imageshow(
                                    imageUrl: shopUrl,
                                    imageAsset: AppImages.appLogo)
                                : Image.asset(
                                    AppImages.appLogo,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_history_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                          ConstantWidgets.width20(context),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
        InkWell(
          onDoubleTap: () {
            context.read<PostLikeAnimationCubit>().showHeart();
            likesOnTap();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeight * heightFactor,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: (postUrl.startsWith('http'))
                      ? imageshow(
                          imageUrl: postUrl,
                          imageAsset: AppImages.appLogo
                          ,
                        )
                      : Image.asset(
                          AppImages.appLogo,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              BlocBuilder<PostLikeAnimationCubit, bool>(
                builder: (context, isVisible) {
                  return AnimatedOpacity(
                    opacity: isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 120),
                    child: AnimatedScale(
                      scale: isVisible ? 1.5 : 0.0,
                      duration: const Duration(milliseconds: 120),
                      child:  Icon(
                        isLiked ? favoriteIcon :Icons.heart_broken,
                        color: AppPalette.redColor,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                favoriteIcon,
                color: favoriteColor,
              ),
              onPressed: likesOnTap,
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.share,
              ),
              onPressed: shareOnTap,
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble,
              ),
              onPressed: commentOnTap,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$likes Appreciations',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              ReadMoreText(
                description,
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppPalette.blueColor,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(color: AppPalette.blueColor),
              ),
              Text(
                dateAndTime,
                style: TextStyle(color: AppPalette.greyColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}