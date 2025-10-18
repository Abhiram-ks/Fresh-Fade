import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/location_bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../../domain/entity/banner_entity.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../../widget/home_widget/home_image_slider.dart';
import '../../widget/home_widget/home_nearyby_map_widget.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: HomePageCustomScrollViewWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        );
      },
    );
  }
}

class HomePageCustomScrollViewWidget extends StatefulWidget {
  const HomePageCustomScrollViewWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<HomePageCustomScrollViewWidget> createState() =>
      _HomePageCustomScrollViewWidgetState();
}

class _HomePageCustomScrollViewWidgetState
    extends State<HomePageCustomScrollViewWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: AppPalette.blackColor,
          expandedHeight: widget.screenHeight * 0.13,
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
                        ? Text(
                          'Fresh Fade',
                          style: GoogleFonts.bellefair(
                            color: AppPalette.whiteColor,
                          ),
                        )
                        : Text(''),
                background: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.screenWidth * 0.04,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<LocationBloc, LocationState>(
                              builder: (context, state) {
                                if (state is LocationLoading) {
                                  return profileviewWidget(
                                    widget.screenWidth,
                                    context,
                                    Icons.location_on,
                                    'Loading...',
                                    AppPalette.orengeColor,
                                  );
                                } else if (state is LocationLoaded) {
                                  return FutureBuilder<String>(
                                    future: getFormattedAddress(
                                      state.position.latitude,
                                      state.position.longitude,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return profileviewWidget(
                                          widget.screenWidth,
                                          context,
                                          Icons.location_on,
                                          'Loading...',
                                          AppPalette.orengeColor,
                                        );
                                      } else if (snapshot.hasError) {
                                        return profileviewWidget(
                                          widget.screenWidth,
                                          context,
                                          Icons.location_on,
                                          'Error fetching location',
                                          AppPalette.orengeColor,
                                        );
                                      } else if (snapshot.hasData) {
                                        return profileviewWidget(
                                          widget.screenWidth,
                                          context,
                                          Icons.location_on,
                                          maxline: 2,
                                          snapshot.data ?? 'Unknown location',
                                          AppPalette.orengeColor,
                                        );
                                      }
                                      return profileviewWidget(
                                        widget.screenWidth,
                                        context,
                                        Icons.location_on,
                                        'Location not available',
                                        AppPalette.orengeColor,
                                      );
                                    },
                                  );
                                }
                                return profileviewWidget(
                                  widget.screenWidth,
                                  context,
                                  Icons.location_on,
                                  'Error fetching location',
                                  AppPalette.orengeColor,
                                );
                              },
                            ),
                            ConstantWidgets.hight10(context),
                            BlocBuilder<FetchUserBloc, FetchUserState>(
                              builder: (context, state) {
                                if (state is FetchUserLoading) {
                                  return Text(
                                    'Loading...',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (state is FetchUserLoaded) {
                                  return Text(
                                    'Hello, ${state.user.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return Text(
                                  'Faching Failure.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: AppPalette.blackColor,
                              ),
                              icon: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: AppPalette.whiteColor,
                              ),
                              onPressed: () {},
                            ),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: AppPalette.blackColor,
                              ),
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                color: AppPalette.orengeColor,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: HomeScreenBodyWIdget(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
          ),
        ),
      ],
    );
  }
}

class HomeScreenBodyWIdget extends StatefulWidget {
  const HomeScreenBodyWIdget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<HomeScreenBodyWIdget> createState() => _HomeScreenBodyWIdgetState();
}

class _HomeScreenBodyWIdgetState extends State<HomeScreenBodyWIdget>
    with AutomaticKeepAliveClientMixin {
  final MapController _mapController = MapController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<FetchBannersBloc, FetchBannerState>(
            builder: (context, state) {
              if (state is FetchBannersLoaded) {
                return ImageSlider(banners: state.banners);
              } else if (state is FetchBannersLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                  highlightColor: AppPalette.whiteColor,
                  child: ImageSlider(
                    banners: BannerEntity(
                      bannerImage: [AppImages.appLogo, AppImages.appLogo],
                      index: 1,
                    ),
                  ),
                );
              }
              return ConstantWidgets.hight10(context);
            },
          ),
          ConstantWidgets.hight30(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find the Best Barbers Near You!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                NearbyShowMapWidget(
                  mapController: _mapController,
                  screenHeight: widget.screenHeight,
                  screenWidth: widget.screenWidth,
                ),
                ConstantWidgets.hight30(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Track Booking Status',
                      style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start,
                    ),
                    Text(
                      "Easily track and manage your bookings, view detailed history and payments, and stay updated with notifications for upcoming appointments.",
                      style: TextStyle(fontSize: 10),
                    ),
                    ConstantWidgets.hight80(context),
                    Center(
                      child: Image.asset(
                        AppImages.appLogo,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    ConstantWidgets.hight10(context),
                    Center(
                      child: Text(
                        "No bookings yet",
                        style: TextStyle(fontWeight: FontWeight.bold),
                         textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Unable to connect to the server. Please contact the administrator for assistance.",
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ConstantWidgets.hight10(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
