
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../screens/setting/setting_screen.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final double screenWidth;

  const ChatAppBar({
    super.key,
    required this.userId,
    required this.screenWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchUserBloc>().add(FetchUserRequest(userId:userId));

    return BlocBuilder<FetchUserBloc, FetchUserState>(
      builder: (context, state) {
         if (state is FetchUserLoaded) {
          final UserEntity user = state.user;

          return AppBar(
            backgroundColor: AppPalette.whiteColor,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            elevation: 4,
            shadowColor: AppPalette.blackColor.withValues(alpha: 0.2),
            scrolledUnderElevation: 4,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.blackColor),
            title: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl: user.photoUrl,
                        imageAsset: AppImages.appLogo,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppPalette.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color:AppPalette.greyColor ,
                          ),
                        ),
                      ],
                    ),
                  ),
                    ConstantWidgets.width40(context),
                ],
              ),
            ),
          );
        } return  AppBar(
            backgroundColor: AppPalette.whiteColor,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 4,
          shadowColor: AppPalette.blackColor.withValues(alpha: 0.15),
          scrolledUnderElevation: 4,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: AppPalette.blackColor),
            title: Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyColor,
          highlightColor: AppPalette.whiteColor,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl:'',
                        imageAsset: AppImages.appLogo,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name Loading..." ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: 16,
                            color: AppPalette.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                         'Loading...',
                          style: TextStyle(
                              fontSize: 16,
                            color:AppPalette.greyColor ,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
