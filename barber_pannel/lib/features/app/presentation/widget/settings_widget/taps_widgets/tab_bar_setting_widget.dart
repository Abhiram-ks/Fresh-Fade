import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/lauch_service_bloc/lauch_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../service/laucher/launcher_service.dart';
import '../../user_detail_widget/custom_functions.dart';
import '../logout_state_handle.dart';

class TabbarSettings extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const TabbarSettings({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidgets.hight20(context),
            Text('Your account', style: TextStyle(color: AppPalette.greyColor)),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.profile_circled,
              title: 'Profile details',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profile,
                  arguments: false,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.square_pencil,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profile,
                  arguments: true,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.password,
                  arguments: false,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.wrench,
              title: 'Service Management',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.serviceManage);
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.clock,
              title: 'Time Management',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.timeManagement);
              },
            ),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.calendar_circle,
                title: 'Booking Management',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.bookingManagement);
                },
              ),
            Divider(color: AppPalette.hintColor),
            ConstantWidgets.hight10(context),
            Text(
              'Community support',
              style: TextStyle(color: AppPalette.greyColor),
            ),
            BlocListener<LauchServiceBloc, LauchServiceState>(
              listener: (context, state) {
                handleEmailLaucher(context, state);
              },
              child: settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.question_circle,
                title: 'Help',
                onTap: () {
                  context.read<LauchServiceBloc>().add(
                    LauchServiceAlertBoxEvent(
                      name: 'Fresh Fade : Business Team',
                      email: 'freshfade.growblic@gmail.com',
                      subject: "To connect with Fresh Fade : Business for help",
                      body:'I would like to receive information on how to use the application effectively and how to get the best results from it in a short amount of time.',
                    ),
                  );
                },
              ),
            ),
            BlocListener<LauchServiceBloc, LauchServiceState>(
              listener: (context, state) {
                handleEmailLaucher(context, state);
              },
              child: settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.bubble_left,
                title: 'Feedback',
                onTap: () {
                  context.read<LauchServiceBloc>().add(
                    LauchServiceAlertBoxEvent(
                      name: 'Fresh Fade : Business Team',
                      email: 'freshfade.growblic@gmail.com',
                      subject: "Feedback on Fresh Fade : Business Application",
                      body:
                          'I would like to provide feedback on the application and suggest improvements for the application.',
                    ),
                  );
                },
              ),
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.star,
              title: 'Rate app',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://play.google.com/store/apps/details?id=com.freshfade.barberpannel&pcampaignid=web_share',
                  name: 'Rate app',
                  context: context,
                );
              },
            ),
            Divider(color: AppPalette.hintColor),
            ConstantWidgets.hight10(context),
            Text(
              'Legal policies',
              style: TextStyle(color: AppPalette.greyColor),
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.doc,
              title: 'Terms & Conditions',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/aa93cfe9-4f94-430f-9391-c8520ea78b74',
                  name: 'Terms & Conditions',
                  context: context,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: CupertinoIcons.shield,
              title: 'Privacy Policy',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/77d4594d-3262-40b2-a5d3-f763982fb4ee',
                  name: 'Privacy Policy',
                  context: context,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: Icons.gavel_rounded,
              title: 'Cookies Policy',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/c7553636-fa5a-4cc0-b9fe-1adef4ec7ff9',
                  name: 'Cookies Policy',
                  context: context,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: Icons.rotate_left_rounded,
              title: 'Service & Refund Policy',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/44ceba71-cd64-4821-b9b5-49cacd0e8923',
                  name: 'Service & Refund Policy',
                  context: context,
                );
              },
            ),
            Divider(color: AppPalette.hintColor),
            ConstantWidgets.hight10(context),
            Text('Login', style: TextStyle(color: AppPalette.greyColor)),
            ConstantWidgets.hight20(context),
            Builder(
              builder: (context) {
                return BlocProvider(
                  create: (context) => sl<LogoutBloc>(),
                  child: BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, logout) {
                      handleLogOutState(context, logout);
                    },
                    child: Builder(
                      builder: (innerContext) {
                        return InkWell(
                          splashColor: AppPalette.trasprentColor,
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: AppPalette.redColor,
                              fontSize: 17,
                            ),
                          ),
                          onTap: () {
                            BlocProvider.of<LogoutBloc>(
                              innerContext,
                            ).add(LogoutRequestEvent());
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            ConstantWidgets.hight10(context),
            BlocListener<LauchServiceBloc, LauchServiceState>(
              listener: (context, state) {
                handleEmailLaucher(context, state);
              },
              child: InkWell(
                onTap: () {
                  context.read<LauchServiceBloc>().add(
                    LauchServiceAlertBoxEvent(
                      name: 'Fresh Fade : Business Team',
                      email: 'freshfade.growblic@gmail.com',
                      subject: "Enquiry about Deleting Account in Fresh Fade : Business",
                      body:
                          'I would like to delete my account from the application. I am a shop owner and I want to know how to delete my account from the application. \n Below i provide my account details for reference:',
                    ),
                  );
                },
                child: Text(
                  "Delete Account?",
                  style: TextStyle(color: AppPalette.redColor),
                ),
              ),
            ),
            ConstantWidgets.hight50(context),
          ],
        ),
      ),
    );
  }
}

ClipRRect settingsWidget({
  required double screenHeight,
  required BuildContext context,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: SizedBox(
      width: double.infinity,
      height: screenHeight * 0.055,
      child: Material(
        color: AppPalette.whiteColor,
        child: InkWell(
          hoverColor: AppPalette.hintColor.withValues(alpha: 0.40),
          splashColor: AppPalette.hintColor.withValues(alpha: 0.19),
          onTap: onTap,
          child: Ink(
            color: AppPalette.whiteColor,
            child: Row(
              children: [
                ConstantWidgets.width20(context),
                Icon(icon, color: AppPalette.blackColor),
                ConstantWidgets.width40(context),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppPalette.blackColor,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppPalette.greyColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
