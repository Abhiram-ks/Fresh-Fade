
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/domain/entity/user_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/launcher_service_bloc/launcher_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_snackbar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/launcher/launcher_service.dart';
import '../../state/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../state/bloc/logout_bloc/logout_bloc.dart';
import '../../widget/widgets/handle_delete_account_widget.dart';
import '../../widget/widgets/handle_email_launcher_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _refreshUser() {
    context.read<FetchUserBloc>().add(FetchUserStarted());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LogoutBloc>()),
        BlocProvider(create: (context) => sl<LauncherServiceBloc>()),
        BlocProvider(create: (context) => sl<DeleteAccountBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: BlocBuilder<FetchUserBloc, FetchUserState>(
                builder: (context, state) {
                  if (state is FetchUserLoading) {
                    return Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.orengeColor,
                          backgroundColor: AppPalette.hintColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  } else if (state is FetchUserLoaded) {
                    return ProfileScrollviewWidget(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      user: state.user,
                    );
                  } else if (state is FetchUserFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to complete the request.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              state.error,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: _refreshUser,
                            icon: Icon(Icons.refresh_rounded),
                          ),
                          BlocListener<LogoutBloc, LogoutState>(
                            listener: (context, state) {
                              handleLogOutState(context, state);
                            },
                            child: TextButton(
                              onPressed: () {
                                context.read<LogoutBloc>().add(
                                  LogoutRequestEvent(),
                                );
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppPalette.redColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: AppPalette.hintColor,
                        backgroundColor: AppPalette.orengeColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScrollviewWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final UserEntity user;
  final ScrollController _scrollController = ScrollController();

  ProfileScrollviewWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: AppPalette.blackColor,
          expandedHeight: screenHeight * 0.27,
          pinned: true,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              bool isCollapsed =
                  constraints.biggest.height <=
                  kToolbarHeight + MediaQuery.of(context).padding.top;
              return FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title:
                    isCollapsed
                        ? Row(
                          children: [
                            ConstantWidgets.width40(context),
                            Text(
                              user.name,
                              style: TextStyle(color: AppPalette.whiteColor),
                            ),
                          ],
                        )
                        : Text(''),
                titlePadding: EdgeInsets.only(left: screenWidth * .04),
                background: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppPalette.greyColor.withAlpha((0.19 * 270).toInt()),
                          BlendMode.modulate,
                        ),
                        child: Image.asset(
                          AppImages.appLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantWidgets.hight30(context),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      color: AppPalette.hintColor,
                                      width: 60,
                                      height: 60,
                                      child:
                                          (user.photoUrl.startsWith('http'))
                                              ? imageshow(
                                                imageUrl: user.photoUrl,
                                                imageAsset: AppImages.appLogo,
                                              )
                                              : Image.asset(
                                                AppImages.appLogo,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                  ConstantWidgets.width40(context),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      profileviewWidget(
                                        screenWidth,
                                        context,
                                        Icons.lock_person_outlined,
                                        "Hello, ${user.name}",
                                        AppPalette.whiteColor,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.profile,
                                            arguments: true,
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              AppPalette.orengeColor,
                                          minimumSize: const Size(0, 0),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 2.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15.0,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                            color: AppPalette.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ConstantWidgets.hight20(context),
                              profileviewWidget(
                                screenWidth,
                                context,
                                Icons.mail_lock_rounded,
                                user.email,
                                AppPalette.hintColor,
                              ),
                              profileviewWidget(
                                screenWidth,
                                context,
                                Icons.mark_as_unread_outlined,
                                'Signed in via Google',
                                AppPalette.buttonColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: CustomSettingsWidget(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
        ),
      ],
    );
  }
}

class CustomSettingsWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const CustomSettingsWidget({
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
            Text('Settings & privacy'),
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
              icon: Icons.book_online,
              title: 'My Booking',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.myBooking,
                );
              },
            ),
            Divider(color: AppPalette.hintColor),
            ConstantWidgets.hight10(context),
            Text(
              'Community support',
              style: TextStyle(color: AppPalette.greyColor),
            ),
            BlocListener<LauncherServiceBloc, LauncherServiceState>(
              listener: (context, state) {
                handleEmailLaucher(context, state);
              },
              child: settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.question_circle,
                title: 'Help',
                onTap: () {
                  context.read<LauncherServiceBloc>().add(
                    LauncherServiceAlertEvent(
                      name: 'Fresh Fade Team',
                      email: 'freshfade.growblic@gmail.com',
                      subject: "To connect with Fresh Fade : Business for help",
                      body:
                          'I would like to receive information on how to use the application effectively and how to get the best results from it in a short amount of time.',
                    ),
                  );
                },
              ),
            ),
            BlocListener<LauncherServiceBloc, LauncherServiceState>(
              listener: (context, state) {
                handleEmailLaucher(context, state);
              },
              child: settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.bubble_left,
                title: 'Feedback',
                onTap: () {
                  context.read<LauncherServiceBloc>().add(
                    LauncherServiceAlertEvent(
                      name: 'Fresh Fade Team',
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
                      'https://play.google.com/store/apps/details?id=com.freshfade.client',
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
                      'https://www.freeprivacypolicy.com/live/5c475448-ba19-41a2-95cc-3b35d16d0fb8',
                  name: 'Terms & Conditions',
                  context: context,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: Icons.gpp_good_outlined,
              title: 'Privacy Policy',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/f9333ad0-99a8-4550-a3da-97f6f94b524a',
                  name: 'Privacy Policy',
                  context: context,
                );
              },
            ),
            settingsWidget(
              context: context,
              screenHeight: screenHeight,
              icon: Icons.gavel_outlined,
              title: 'Cookies Policy',
              onTap: () {
                LauncerService.launchingFunction(
                  url:
                      'https://www.freeprivacypolicy.com/live/00d9f0de-254b-42da-b97a-0feca46562d5',
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
                      'https://www.freeprivacypolicy.com/live/eabfe916-6c9c-4b76-8aad-4bf754e803e1',
                  name: 'Service & Refund Policy',
                  context: context,
                );
              },
            ),
            Divider(color: AppPalette.hintColor),
            ConstantWidgets.hight10(context),
            Text('Login', style: TextStyle(color: AppPalette.greyColor)),
            ConstantWidgets.hight20(context),
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                handleLogOutState(context, state);
              },
              child: InkWell(
                onTap: () {
                  context.read<LogoutBloc>().add(LogoutRequestEvent());
                },
                splashColor: AppPalette.trasprentColor,
                child: Text(
                  'Log out',
                  style: TextStyle(color: AppPalette.redColor, fontSize: 17),
                ),
              ),
            ),
            ConstantWidgets.hight10(context),
            BlocListener<DeleteAccountBloc, DeleteAccountState>(
              listener: (context, state) {
                handleDeleteAccountState(context, state);
              },
              child: InkWell(
                onTap: () {
                  context.read<DeleteAccountBloc>().add(DeleteAccountAlertBoxEvent());

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
          hoverColor: AppPalette.hintColor.withValues(alpha: 0.19),
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
                    style: TextStyle(color: AppPalette.blackColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppPalette.greyColor,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Image imageshow({required String imageUrl, required String imageAsset}) {
  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress != null) {
        double? progress;
        if (loadingProgress.expectedTotalBytes != null) {
          progress =
              loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!;
        }

        return Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4.0,
              color: AppPalette.buttonColor,
            ),
          ),
        );
      }
      return child;
    },
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    },
  );
}

SizedBox profileviewWidget(
  double screenWidth,
  BuildContext context,
  IconData icons,
  String heading,
  Color iconclr, {
  Color? textColor,
  int? maxline,
  double? widget,
}) {
  return SizedBox(
    width: widget ?? screenWidth * 0.55,
    child: Row(
      children: [
        Icon(icons, color: iconclr),
        ConstantWidgets.width20(context),
        Expanded(
          child: Text(
            heading,
            style: TextStyle(
              color: textColor ?? AppPalette.whiteColor,
              fontSize: 12,
            ),
            maxLines: maxline ?? 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

void handleLogOutState(BuildContext context, LogoutState state) {
  if (state is LogoutAlertState) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext modalContext) => CupertinoActionSheet(
            title: Text('Session Expiration Warning!'),
            message: Text(
              "Are you sure you want to logout? This will remove your session and log you out.",
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(modalContext);
                  context.read<LogoutBloc>().add(LogoutConfirmEvent());
                },
                isDefaultAction: true,
                child: Text(
                  'Yes, Log Out',
                  style: TextStyle(fontSize: 14, color: AppPalette.redColor),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(modalContext);
              },
              isDestructiveAction: true,
              child: Text(
                'No, Cancel',
                style: TextStyle(color: AppPalette.blackColor, fontSize: 14),
              ),
            ),
          ),
    );
  } else if (state is LogoutSuccessState) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  } else if (state is LogoutErrorState) {
    CustomSnackBar.show(
      context,
      message: state.error,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  }
}
