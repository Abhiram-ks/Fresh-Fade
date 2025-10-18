
import 'package:client_pannel/features/app/data/repo/barbershop_repo_impl.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../auth/presentations/state/cubit/nav_cubit/nav_cubit.dart';
import '../../domain/usecase/get_location_usecase.dart';
import '../state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import '../state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fech_post_with_barber_bloc.dart';
import '../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../state/bloc/location_bloc/location_bloc.dart';
import '../state/cubit/like_post_cubit/like_post_cubit.dart';
import '../state/cubit/post_like_animation_cubit/post_like_animation_cubit.dart';
import '../state/cubit/share_cubit/share_cubit.dart';
import '../state/cubit/voice_cubit/voice_cubit.dart';
import 'chats/chats_screen.dart';
import 'home/home_screen.dart';
import 'posts/posts_screen.dart';
import 'search/search_screen.dart';
import 'settings/settings_screen.dart';

const double bottomNavBarHeight = 70.0;

class BottomNavigationControllers extends StatelessWidget {
  const BottomNavigationControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchUserBloc>()..add(FetchUserStarted())),
        BlocProvider(create: (context) => ButtomNavCubit()),
        BlocProvider(create: (context) => LocationBloc(GetLocationUseCase())..add(GetCurrentLocationEvent())),
        BlocProvider(create: (context) => sl<FetchBannersBloc>()..add(FetchBannersRequest())),
        BlocProvider(create: (_) => NearbyBarbersBloc(GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(create: (context) => sl<FechPostWithBarberBloc>()..add(FetchPostWithBarberRequest())),
        BlocProvider(create: (context) => LikePostCubit()),
        BlocProvider(create: (context) => PostLikeAnimationCubit()),
        BlocProvider(create: (context) => sl<ShareCubit>()), 
        BlocProvider(create: (context) => sl<FetchAllbarberBloc>()..add(FetchAllBarbersRequested())),
        BlocProvider(create: (context) => sl<VoiceSearchCubit>()), 
        
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppPalette.whiteColor.withAlpha((0.3 * 225).round()),
          highlightColor: AppPalette.buttonColor.withAlpha((0.2 * 255).round()),
        ),
        child:  SafeArea(
            child: Scaffold(
              body: BlocBuilder<ButtomNavCubit, NavItem>(
                builder: (context, state) {
                  return IndexedStack(
                    index: NavItem.values.indexOf(state),
                    children: const [
                      HomeScreen(),
                      SearchScreen(),
                      PostsScreen(),
                      ChatsScreen(),
                      SettingsScreen(),
                    ],
                  );
                },
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
                            icon: Icon(CupertinoIcons.search, size: 16),
                            label: 'Search',
                            activeIcon: Icon(
                             CupertinoIcons.search,
                              color: AppPalette.buttonColor,
                            ),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.play_rectangle, size: 16),
                            label: 'Posts',
                            activeIcon: Icon(
                              CupertinoIcons.play_rectangle_fill,
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
                            icon: Icon(CupertinoIcons.person, size: 16),
                            label: 'Account',
                            activeIcon: Icon(
                             CupertinoIcons.person_fill,
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
