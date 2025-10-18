import 'package:client_pannel/features/app/presentations/widget/post_widget/post_cards_widgets.dart';
import 'package:flutter/material.dart';

class PostScreenMainWidget extends StatelessWidget {
  final double screenHeight;
  final double heightFactor;
  final double screenWidth;
  final String postUrl;
  final String shopUrl;
  final String shopName;
  final String location;
  final int likes;
  final String description;
  final VoidCallback profilePage;
  final VoidCallback likesOnTap;
  final VoidCallback shareOnTap;
  final VoidCallback chatOnTap;
  final VoidCallback commentOnTap;
  final Color favoriteColor;
  final IconData favoriteIcon;
  final String dateAndTime;
  final bool isLiked;

  const PostScreenMainWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
    required this.postUrl,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.likes,
    required this.description,
    required this.profilePage,
    required this.likesOnTap,
    required this.shareOnTap,
    required this.chatOnTap,
    required this.favoriteColor,
    required this.favoriteIcon,
    required this.dateAndTime,
    required this.commentOnTap, required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return PostgScreenGenerateWIdget(
      profilePage: profilePage,
      shopUrl: shopUrl,
      shopName: shopName,
      location: location,
      isLiked: isLiked,
      likesOnTap: likesOnTap,
      screenHeight: screenHeight,
      heightFactor: heightFactor,
      postUrl: postUrl,
      favoriteIcon: favoriteIcon,
      favoriteColor: favoriteColor,
      shareOnTap: shareOnTap,
      commentOnTap: commentOnTap,
      chatOnTap: chatOnTap,
      screenWidth: screenWidth,
      likes: likes,
      description: description,
      dateAndTime: dateAndTime,
    );
  }
}
