import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/routes/routes.dart' show AppRoutes;
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/presentation/widget/home_widget/home_image_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import '../../state/bloc/lauch_service_bloc/lauch_service_bloc.dart';
import '../../widget/home_widget/time_line_builder_pending_widget.dart' show TimelineBuilderPendings;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LauchServiceBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Scaffold(
            appBar: CustomAppBar2(
              isTitle: true,
              title: 'Dashboard Overview',
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.wallet);
                  },
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.notification);
                  },
                  icon: const Icon(
                    Icons.notifications_active_sharp,
                    color: AppPalette.buttonColor,
                  ),
                ),
                ConstantWidgets.width20(context),
              ],
            ),
            body: HomePageCustomScrollViewWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          );
        },
      ),
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          HomeScreenBodyWidget(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
          ),
        ],
      ),
    );
  }
}

class HomeScreenBodyWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const HomeScreenBodyWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(
              horizontal:
                  screenWidth > 600 ? screenWidth * .15 : screenWidth * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Upcoming Bookings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                  ConstantWidgets.hight10(context),
                TimelineBuilderPendings(),
                ConstantWidgets.hight10(context),
                Text(
                  'Track Booking Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Easily track and manage your bookings, view detailed history and payments, and stay updated with notifications for upcoming appointments.",
                  style: TextStyle(fontSize: 10),
                ),
                ConstantWidgets.hight80(context),
                Center(
                  child: Image.asset(AppImages.appLogo, height: 50, width: 50),
                ),
                ConstantWidgets.hight10(context),
                Center(
                  child: Text(
                    "No bookings yet",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}
