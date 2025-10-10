import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_image_show_widget.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_post_add_widget.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_setting_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Scaffold(
          body: BlocBuilder<FetchBarberBloc, FetchBarberState>(
            builder: (context, state) {
              if (state is FetchBarberLoading) {
                 return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: AppPalette.hintColor,
                        backgroundColor: AppPalette.buttonColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                    ConstantWidgets.width20(context),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
              }
              if (state is FetchBarberLoaded) {
                return ProfileScrollView(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  barber: state.barber,
                );
              }
              return  ProfileScrollView(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  barber: BarberEntity(
                    barberName: '',
                    image: '',
                    ventureName: '',
                    email: '',
                    address: '',
                    uid: '',
                    phoneNumber: '',
                    isVerified: false,
                    isBloc: false,
                  ),
                );
             
            },
          ),
        );
      },
    );
  }
}



class ProfileScrollView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final BarberEntity barber;

  const ProfileScrollView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barber,
  });

  @override
  State<ProfileScrollView> createState() => _ProfileScrollViewState();
}

class _ProfileScrollViewState extends State<ProfileScrollView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppPalette.blackColor,
              expandedHeight: widget.screenHeight * 0.35,
              pinned: true,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                bool isCollapsed = constraints.biggest.height <=
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: isCollapsed
                      ? Row(
                          children: [
                            ConstantWidgets.width40(context),
                            Text( widget.barber.barberName,
                            style: TextStyle(color: AppPalette.whiteColor),
                            ),
                          ],
                        ): Text(''),
                  titlePadding: EdgeInsets.only(left: widget.screenWidth * .04),
                  background: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.screenWidth * 0.08,
                        ), child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstantWidgets.hight30(context),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      color: AppPalette.greyColor,
                                      width: 60,   height: 60,
                                      child: (widget.barber.image != null &&
                                              widget.barber.image!
                                                  .startsWith('http'))
                                          ? imageshow(
                                              imageUrl: widget.barber.image!,
                                              imageAsset:AppImages.appLogo)
                                          : Image.asset(
                                              AppImages.appLogo, fit: BoxFit.cover,
                                            )),
                                ),
                                ConstantWidgets.width40(context),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    profileviewWidget(
                                      widget.screenWidth, context,  Icons.lock_person_outlined,"Hello, ${widget.barber.barberName}",AppPalette.whiteColor,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.pushNamed(context,AppRoutes.accountScreen,arguments: true);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:AppPalette.whiteColor,
                                        minimumSize: const Size(0, 0),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,vertical: 2.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      child: const Text( "Edit Profile",style: TextStyle(color: AppPalette.buttonColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            ConstantWidgets.hight30(context),
                            profileviewWidget(
                              widget.screenWidth,context, Icons.add_business_rounded,widget.barber.ventureName, AppPalette.whiteColor,
                            ),
                            profileviewWidget(
                              widget.screenWidth,context, Icons.attach_email,widget.barber.email, AppPalette.whiteColor,
                            ),
                            profileviewWidget(
                              widget.screenWidth,context,Icons.location_on_rounded,widget.barber.address, AppPalette.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  automaticIndicatorColorAdjustment: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: AppPalette.buttonColor,
                  labelColor: AppPalette.whiteColor,
                  unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_view_rounded)),
                    Tab(icon: Icon(CupertinoIcons.photo)),
                    Tab(icon: Icon(Icons.settings)),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: AnimatedBuilder(
                animation: _tabController,
                builder: (context, child) {
                  return _buildTabContent(_tabController.index, widget.screenHeight, widget.screenWidth, context, _scrollController, widget.barber);
                },
              ),
            ),
          ],
        );
  }
}



class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppPalette.blackColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}





//Tabbar bodys

Widget _buildTabContent(int tabIndex, double screenHeight, double screenWidth,
    BuildContext context, ScrollController scrollController, BarberEntity barber) {
  switch (tabIndex) {
    case 0:
      return TabbarImageShow();
    case 1:
      return TabbarAddPost(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        scrollController: scrollController,
      );
    case 2:
      return TabbarSettings(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      );
    default:
      return Center(child: Text("Unknown Tab"));
  }
}




Image imageshow({required String imageUrl,required String imageAsset}) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppPalette.buttonColor,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          imageAsset,
          fit: BoxFit.cover,
        );
      },
    );
  }



   SizedBox profileviewWidget(double screenWidth, BuildContext context,
      IconData icons, String heading, Color iconclr, {Color? textColor, int? maxLines}) {
    return SizedBox(
      width: screenWidth * 0.55,
      child: Row(children: [
        Icon(
          icons,
          color: iconclr,
          size: 15,
        ),
        ConstantWidgets.width20(context),
        Expanded(
          child: Text(
            heading,
            style: TextStyle(
              color: textColor ?? AppPalette.whiteColor,
            ),
            maxLines: maxLines ?? 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }

IconButton iconsFilledDetail(
    {required BuildContext context,
    required Color fillColor,
    required double borderRadius,
    required Color forgroudClr,
    required double padding,
    required VoidCallback onTap,
    required IconData icon}) {
  return IconButton.filled(
    onPressed: onTap,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      backgroundColor: fillColor,
      foregroundColor: forgroudClr,
      padding: EdgeInsets.all(padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}




  Column detailsPageActions(
      {required BuildContext context,
      required double screenWidth,
      required IconData icon,
      required VoidCallback onTap,
      Color ? colors,
      required String text}) {
    return Column(
      children: [
        iconsFilledDetail(
          icon: icon,
          forgroudClr:colors ?? AppPalette.buttonColor,
          context: context,
          borderRadius: 15,
          padding:screenWidth > 600 ? 30 : screenWidth * .05,
          fillColor: Color.fromARGB(255, 248, 239, 216),
          onTap: onTap,
        ),
        Text(text)
      ],
    );
  }

