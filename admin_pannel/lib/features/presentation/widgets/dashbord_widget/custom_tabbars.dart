import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logout_widget/logout_state_handle.dart';

class TabBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const TabBarCustom({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPalette.whiteColor,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Fresh Fade',
            style: GoogleFonts.bellefair(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text('Admin Portel', style: GoogleFonts.poppins(fontSize: 10)),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * .04),
          child: BlocListener<LogoutBloc, LogoutState>(
            listener: (context, logout) {
              handleLogoutState(context, logout);
            },
            child: IconButton(
              onPressed: () {
                context.read<LogoutBloc>().add(LogoutActionEvent());
              },
              icon: Icon(CupertinoIcons.square_arrow_right),
            ),
          ),
        ),
      ],
      bottom: TabBar(
        tabAlignment: TabAlignment.fill,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 3.0, color: AppPalette.blueColor),
        ),
        labelColor: AppPalette.blueColor,
        unselectedLabelColor: AppPalette.greyColor,
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
