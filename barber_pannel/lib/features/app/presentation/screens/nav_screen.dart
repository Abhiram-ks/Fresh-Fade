import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_chat_user_lebel_bloc/fetch_chat_user_lebel_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/nav_cubit/nav_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat/chat_screen.dart';
import 'home/home_screen.dart';
import 'revenue/revenu_screen.dart';
import 'service/service_screen.dart';

const double bottomNavBarHeight = 70.0;

class BottomNavigationControllers extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    RevenueScreen(),
    ServiceScreen(),
    ChatScreen(),
    SettingScreen(),
  ];

  BottomNavigationControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtomNavCubit()),
        BlocProvider(
          create:
              (context) => sl<FetchBannersBloc>()..add(FetchBannersRequest()),
        ),
        BlocProvider(
          create: (context) => sl<FetchBarberBloc>()..add(FetchBarberRequest()),
        ),
        BlocProvider(
          create: (context) => sl<FetchPostsBloc>()..add(FetchPostsRequest()),
        ),
        BlocProvider(
          create: (context) => sl<FetchChatUserlebelBloc>()..add(FetchChatLebelUserRequst()),
        ),
        BlocProvider(
          create: (context) => sl<FetchBarberServiceBloc>()..add(FetchBarberServiceRequest()),
        ),
        BlocProvider(
          create: (context) => sl<FetchBookingWithUserBloc>()..add(FetchBookingWithUserFilteredRequested(status: 'pending')),
        ),
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppPalette.whiteColor.withAlpha((0.3 * 225).round()),
          highlightColor: AppPalette.buttonColor.withAlpha((0.2 * 255).round()),
        ),
        child: SafeArea(
            child: Scaffold(
              body: BlocListener<FetchBarberBloc, FetchBarberState>(
                listener: (context, state) {
                  if (state is FetchBarberLoaded) {
                    if (state.barber.isBloc == true) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  }
                },
                child: BlocBuilder<ButtomNavCubit, NavItem>(
                  builder: (context, state) {
                    switch (state) {
                      case NavItem.home:
                        return _screens[0];
                      case NavItem.revenue:
                        return _screens[1];
                      case NavItem.service:
                        return _screens[2];
                      case NavItem.chat:
                        return _screens[3];
                      case NavItem.profile:
                        return _screens[4];
                    }
                  },
                ),
              ),
              bottomNavigationBar: BlocBuilder<ButtomNavCubit, NavItem>(
                builder: (context, state) {
                  return SizedBox(
                    height: bottomNavBarHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.blackColor.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: BottomNavigationBar(
                        enableFeedback: true,
                        useLegacyColorScheme: true,
                        elevation: 0,
                        iconSize: 26,
                        selectedItemColor: AppPalette.buttonColor,
                        backgroundColor: Colors.transparent,
                        landscapeLayout:
                            BottomNavigationBarLandscapeLayout.spread,
                        unselectedLabelStyle: TextStyle(
                          color: AppPalette.hintColor,
                        ),
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: NavItem.values.indexOf(state),
                        onTap: (index) {
                          context.read<ButtomNavCubit>().selectItem(
                            NavItem.values[index],
                          );
                        },
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined, size: 16),
                            label: 'Home',
                            activeIcon: Icon(
                              Icons.home,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.cloud_queue, size: 16),
                            label: 'Revenue',
                            activeIcon: Icon(
                              Icons.cloud,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.scissors, size: 16),
                            label: 'Service',
                            activeIcon: Icon(
                              CupertinoIcons.scissors,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.chat_bubble_2, size: 16),
                            label: 'Chat',
                            activeIcon: Icon(
                              CupertinoIcons.chat_bubble_2_fill,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.settings, size: 16),
                            label: 'Setting',
                            activeIcon: Icon(
                              Icons.settings,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ),
    );
  }
}
