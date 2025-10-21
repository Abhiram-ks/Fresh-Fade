import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../screen/settings/settings_screen.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String barberId;
  final double screenWidth;

  const ChatAppBar({
    super.key,
    required this.barberId,
    required this.screenWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchAbarberBloc>().add(FetchABarberEventRequest(barberId:  barberId));

    return BlocBuilder<FetchAbarberBloc, FetchAbarberState>(
      builder: (context, state) {
        if (state is FetchABarberSuccess) {
          final barber = state.barber;

          return AppBar(
            backgroundColor: AppPalette.whiteColor,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            elevation: 4,
            shadowColor: AppPalette.blackColor.withValues(alpha: 0.15),
            scrolledUnderElevation: 4,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.blackColor),
            title: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.detailBarber, arguments: barberId),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl: barber.image ?? '',
                        imageAsset: AppImages.barberEmpty,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber.ventureName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: AppPalette.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          barber.email,
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: screenWidth * 0.032,
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
        }
        return AppBar(
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
                      imageUrl: '',
                      imageAsset: AppImages.barberEmpty,
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Venture Name Loading...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: AppPalette.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'loading...',
                        style: TextStyle(
                          color: AppPalette.greyColor,
                          fontSize: screenWidth * 0.035,
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
