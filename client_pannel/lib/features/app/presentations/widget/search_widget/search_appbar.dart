import 'package:client_pannel/features/app/presentations/widget/search_widget/search_filter_widget.dart' show serchFilterActionItems;
import 'package:flutter/material.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: AppPalette.whiteColor,
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      surfaceTintColor: AppPalette.whiteColor,
      width: screenWidth * 0.8,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.13,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppPalette.blackColor,
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter By',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Customize your search to find the perfect match faster and smarter.',
                    style: TextStyle(color: AppPalette.whiteColor, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                  )
                ],
              ),
            ),
          ),
          ConstantWidgets.hight10(context),
         serchFilterActionItems(screenWidth, context, screenHeight)
        ],
      ),
    );
  }
}
