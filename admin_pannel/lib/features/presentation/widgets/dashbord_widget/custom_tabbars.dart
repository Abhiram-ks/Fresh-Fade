import 'package:admin_pannel/core/images/images.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const TabBarCustom({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPalette.whiteColor,
      title: Row(
        children: [
          Image.asset(
              AppImages.appLogo,
              width: 55,
              height: 55,
              fit: BoxFit.contain,
            ),
          Text(
            'Fresh Fade',
            style: GoogleFonts.bellefair(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * .04),
          child: IconButton(
            onPressed: () {
            
            },
            icon: Icon(CupertinoIcons.square_arrow_right),
          ),
        ),
      ],
      bottom: TabBar(
        tabAlignment: TabAlignment.fill,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 3.0, color: AppPalette.blackColor),
        ),
        labelColor: AppPalette.blackColor,
        unselectedLabelColor: AppPalette.blackColor,
        tabs: [
          Tab(text: 'Administration'),
          Tab(text: 'Services'),
          Tab(text: 'Promotions'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}
