import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';


class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Scaffold(
          appBar: CustomAppBar2(
            isTitle: true,
            title: 'Revenue Details',
            actions: [
              IconButton(
                onPressed: () {
                  CustomCupertinoDialog.show(
                    context: context,
                    title: 'Revenue Overview',
                    message: 'Track revenue effectively and monitor your shop\'s financial performance. If you\'re currently unable to access revenue features, please connect with administration for assistance. Revenue tracking helps with monitoring, analysis, and provides visual presentation to show your revenue status and trends.',
                    firstButtonText: 'Got it',
                    secondButtonText: 'Close',
                    firstButtonColor: AppPalette.buttonColor,
                    onTap: () {},
                  );
                },
                icon: Icon(Icons.help_outline_outlined, color: AppPalette.buttonColor),
              ),
              ConstantWidgets.width10(context),
            ],
          ),
          body: RevenueScreenBodyWidget(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        );
      },
    );
  }
}

class RevenueScreenBodyWidget extends StatefulWidget {
  const RevenueScreenBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<RevenueScreenBodyWidget> createState() =>
      _RevenueScreenBodyWidgetState();
}

class _RevenueScreenBodyWidgetState extends State<RevenueScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal:
            widget.screenWidth > 600
                ? widget.screenWidth * 0.15
                : widget.screenWidth * .03,
      ),
      child: Column(
        children: [
          ConstantWidgets.hight10(context),
          RevanueContainer(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
          ),
          ConstantWidgets.hight10(context),
          RevenuePortionGridWidget(widget: widget),
        ],
      ),
    );
  }
}

// Revenue card
class RevanueContainer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const RevanueContainer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppPalette.buttonColor,
              Color.fromARGB(255, 154, 108, 232),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Track and Analyze Revenue',
                      style: TextStyle(
                        color: AppPalette.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Here\'s an overview of your shop',
                      style: TextStyle(
                        color: AppPalette.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.025,
                  bottom: screenHeight * 0.025,
                  left: screenWidth * 0.045,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(102),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.auto_graph_sharp,
                    color: AppPalette.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevenuePortionGridWidget extends StatelessWidget {
  const RevenuePortionGridWidget({super.key, required this.widget});

  final RevenueScreenBodyWidget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.screenHeight * 0.9,
      child: GridView.count(
        crossAxisCount: widget.screenWidth > 600 ? 3 : 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 2,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          InkWell(
            onTap: () {},
            child: RevenueDetailsContainer(
              gradient: const LinearGradient(
                colors: [
                  AppPalette.buttonColor,
                  Color.fromARGB(255, 190, 157, 248),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              title: 'Total Revenu',
              description: 'A clear snapshot of your earnings.',
              icon: Icons.currency_rupee_sharp,
              salesText: 'No Bookings',
              iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
            ),
          ),
          InkWell(
            onTap: () {},
            child: RevenueDetailsContainer(
              gradient: const LinearGradient(
                colors: [
                  AppPalette.buttonColor,
                  Color.fromARGB(255, 190, 157, 248),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              title: 'Today’s Earnings',
              description: 'A focused glimpse of your daily hustle.',
              icon: Icons.shopping_basket,
              salesText: 'No Bookings',
              iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.serviceManage);
            },
            child: BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>(
              builder: (context, state) {
                String serviceCount = '0';
                if (state is FetchBarberServiceLoading) {
                  serviceCount = 'Loading...';
                } else if (state is FetchBarberServiceLoaded) {
                  serviceCount = state.services.length.toString();
                } else if (state is FetchBarberServiceEmpty) {
                  serviceCount = 'No services found';
                } else if (state is FetchBarberServiceError) {
                  serviceCount = 'Error: Try Again';
                }
                return RevenueDetailsContainer(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 190, 157, 248),
                      AppPalette.buttonColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  title: 'Total Services',
                  description:
                      "The total count of every service you’ve provided",
                  icon: CupertinoIcons.wrench_fill,
                  salesText: serviceCount,
                  iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                );
              },
            ),
          ),
          InkWell(
            onTap: () {},
            child: RevenueDetailsContainer(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 190, 157, 248),
                  AppPalette.buttonColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              title: 'Total Customers',
              description:
                  'The clients who’ve chosen you as their go-to barber',
              icon: Icons.people,
              salesText: 'No Bookings',
              iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
            ),
          ),
          InkWell(
            onTap: () {},
            child: RevenueDetailsContainer(
              gradient: const LinearGradient(
                colors: [
                  AppPalette.buttonColor,
                  Color.fromARGB(255, 190, 157, 248),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              title: 'Work Legacy',
              description:
                  "The accumulated hours of your craft, reflecting a lifetime of skill and passion.",
              icon: CupertinoIcons.timer_fill,
              salesText: 'No Bookings',
              iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
            ),
          ),
          InkWell(
            onTap: () {},
            child: RevenueDetailsContainer(
              gradient: const LinearGradient(
                colors: [
                  AppPalette.buttonColor,
                  Color.fromARGB(255, 190, 157, 248),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              title: 'Total Bookings',
              description:'Every booking is a step towards building your success.',
              icon: Icons.book,
              salesText: 'No Bookings',
              iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueDetailsContainer extends StatelessWidget {
  final Gradient gradient;
  final double screenHeight;
  final double screenWidth;
  final IconData icon;
  final Color iconColor;
  final String salesText;
  final String title;
  final String description;

  const RevenueDetailsContainer({
    super.key,
    required this.gradient,
    required this.screenHeight,
    required this.screenWidth,
    required this.icon,
    required this.iconColor,
    required this.salesText,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenWidth / 2,
          height: screenHeight * 0.2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidgets.hight10(context),
                  Icon(icon, size: 30, color: AppPalette.whiteColor),
                  ConstantWidgets.hight10(context),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppPalette.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppPalette.whiteColor,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    salesText,
                    style: const TextStyle(
                      color: AppPalette.whiteColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 1,
          right: 0,
          child: Icon(icon, color: iconColor, size: 70),
        ),
      ],
    );
  }
}
