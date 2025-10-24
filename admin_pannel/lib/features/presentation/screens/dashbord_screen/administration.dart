import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/images/images.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/domain/entity/barber_entity.dart';
import 'package:admin_pannel/features/presentation/screens/dashbord_screen/service.dart';
import 'package:admin_pannel/features/presentation/state/bloc/bloc_and_unbloc_bloc/blocandunbloc_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/toggleview_bloc/toggleview_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/adminstration_widget/administration_blocunbloc_state_handle.dart';
import 'package:admin_pannel/features/presentation/widgets/adminstration_widget/administration_request_state_handle.dart';
import 'package:admin_pannel/features/presentation/widgets/dashbord_widget/dashboard_filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/di.dart';
import '../../state/bloc/request_bloc/request_bloc.dart';

class AdministrationScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const AdministrationScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchBarberBloc>()),
        BlocProvider(create: (context) => sl<RequestBloc>()),
        BlocProvider(create: (context) => sl<BlocandunblocBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check if it's a large screen (web/tablet)
          bool isLargeScreen = screenWidth > 900;

          return isLargeScreen
              ? WebResponsiveAdministrationLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )
              : MobileAdministrationLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              );
        },
      ),
    );
  }
}

// Mobile Layout (unchanged)
class MobileAdministrationLayout extends StatefulWidget {
  const MobileAdministrationLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<MobileAdministrationLayout> createState() =>
      _MobileAdministrationLayoutState();
}

class _MobileAdministrationLayoutState extends State<MobileAdministrationLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBarberBloc>().add(FetchAllBarbersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            widget.screenWidth > 600
                ? widget.screenWidth * .2
                : widget.screenWidth * 0.03,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstantWidgets.hight10(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardFilters(
                message: 'Manage Bookings',
                icon: CupertinoIcons.calendar,
                action: () {},
              ),
              DashboardFilters(
                message: 'Wallet Configuration',
                icon: Icons.account_balance_wallet,
                action: () {},
              ),
              DashboardFilters(
                message: 'Administration Enquiries',
                icon: Icons.person_search,
                action: () {
                  context.read<ToggleviewBloc>().add(ToggleviewAction());
                },
              ),
            ],
          ),
          ConstantWidgets.hight10(context),
          BlocBuilder<ToggleviewBloc, ToggleviewState>(
            builder: (context, state) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state is ToggleviewStatus
                      ? 'Administration Status'
                      : 'Administration Requests',
                  style: GoogleFonts.bellefair(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ToggleviewBloc, ToggleviewState>(
              builder: (context, state) {
                return state is ToggleviewStatus
                    ? BarbersStatusBuilder(
                      screenHeight: widget.screenHeight,
                      screenWidth: widget.screenWidth,
                    )
                    : RequstBlocBuilder(
                      screenHeight: widget.screenHeight,
                      screenWidth: widget.screenWidth,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Web Responsive Layout for Large Screens
class WebResponsiveAdministrationLayout extends StatefulWidget {
  const WebResponsiveAdministrationLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<WebResponsiveAdministrationLayout> createState() =>
      _WebResponsiveAdministrationLayoutState();
}

class _WebResponsiveAdministrationLayoutState
    extends State<WebResponsiveAdministrationLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBarberBloc>().add(FetchAllBarbersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400, minWidth: 1000),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Sidebar - Administration Info
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.blackColor.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppPalette.blueColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  CupertinoIcons.person_2,
                                  color: AppPalette.blueColor,
                                  size: 24,
                                ),
                              ),
                              ConstantWidgets.width20(context),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Administration',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppPalette.blackColor,
                                      ),
                                    ),
                                    Text(
                                      'Manage barbers and requests',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppPalette.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ConstantWidgets.hight30(context),

                          // Quick Actions
                          InkWell(
                            onTap: () {
                              context.read<ToggleviewBloc>().add(
                                ToggleviewAction(),
                              );
                            },
                            child: buildInfoCard(
                              icon: Icons.person_search,
                              title: 'Administration Enquiries',
                              description: 'Review and manage barber requests',
                              color: AppPalette.orengeColor,
                            ),
                          ),
                          ConstantWidgets.hight20(context),
                          buildInfoCard(
                            icon: CupertinoIcons.calendar,
                            title: 'Manage Bookings',
                            description: 'View and manage appointment bookings',
                            color: AppPalette.blueColor,
                          ),
                          ConstantWidgets.hight20(context),
                          buildInfoCard(
                             icon: Icons.account_balance_wallet,
                            title: 'Wallet Configuration',
                            description:
                                'Configure payment and wallet settings',
                            color: AppPalette.greenColor,
                          ),
                          ConstantWidgets.hight30(context),
                          // Stats Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppPalette.blueColor.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppPalette.blueColor.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.chart_bar,
                                      color: AppPalette.blueColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Quick Stats',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppPalette.blueColor,
                                      ),
                                    ),
                                  ],
                                ),
                                ConstantWidgets.hight10(context),
                                Text(
                                  'Monitor barber registrations, active accounts, and pending requests in real-time.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppPalette.greyColor,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Right Side - Administration Content
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppPalette.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.blackColor.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Content Header
                        BlocBuilder<ToggleviewBloc, ToggleviewState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Icon(
                                  state is ToggleviewStatus
                                      ? CupertinoIcons.person_2_fill
                                      : CupertinoIcons.person_badge_plus,
                                  color: AppPalette.blueColor,
                                  size: 24,
                                ),
                                ConstantWidgets.width20(context),
                                Text(
                                  state is ToggleviewStatus
                                      ? 'Administration Status'
                                      : 'Administration Requests',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppPalette.blackColor,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        state is ToggleviewStatus
                                            ? AppPalette.greenColor.withValues(
                                              alpha: 0.1,
                                            )
                                            : AppPalette.orengeColor.withValues(
                                              alpha: 0.1,
                                            ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    state is ToggleviewStatus
                                        ? 'Status View'
                                        : 'Request View',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color:
                                          state is ToggleviewStatus
                                              ? AppPalette.greenColor
                                              : AppPalette.orengeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        ConstantWidgets.hight20(context),

                        // Content Area
                        Expanded(
                          child: BlocBuilder<ToggleviewBloc, ToggleviewState>(
                            builder: (context, state) {
                              return state is ToggleviewStatus
                                  ? BarbersStatusBuilder(
                                    screenHeight: widget.screenHeight,
                                    screenWidth: widget.screenWidth,
                                  )
                                  : RequstBlocBuilder(
                                    screenHeight: widget.screenHeight,
                                    screenWidth: widget.screenWidth,
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class BarbersStatusBuilder extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const BarbersStatusBuilder({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocandunblocBloc, BlocandunblocState>(
      listener: (context, blocunbloc) {
        blocUnblocStateHandle(context, blocunbloc);
      },
      child: BlocBuilder<FetchBarberBloc, FetchBarberState>(
        builder: (context, state) {
          if (state is FetchBarberLoading) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: AppPalette.hintColor,
                      backgroundColor: AppPalette.blueColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPalette.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is FetchBarberEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "There's nothing here yet.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'No administration records available yet.',
                    style: TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is FetchBarberLoaded) {
            final registedBarbers =
                state.barbers
                    .where((barber) => barber.isVerified == true)
                    .toList();

            if (registedBarbers.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "There's nothing here yet.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'No administration records available yet.',
                      style: TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: registedBarbers.length,
              itemBuilder: (context, index) {
                final barber = registedBarbers[index];
                return RequestCardWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  barber: barber,
                  postive: 'UnBlock',
                  onPostive: () {
                    if (barber.isBloc) {
                      context.read<BlocandunblocBloc>().add(
                        ShowUnBlacAlertEvent(
                          uid: barber.uid,
                          name: barber.barberName,
                          ventureName: barber.ventureName,
                        ),
                      );
                    } else {
                      CustomSnackBar.show(
                        context,
                        message: "Account Alredy Active",
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                  negative: 'Block',
                  onNegative: () {
                    if (barber.isBloc) {
                      CustomSnackBar.show(
                        context,
                        message: "Account Alredy Suspended",
                        textAlign: TextAlign.center,
                      );
                    } else {
                      context.read<BlocandunblocBloc>().add(
                        ShowBlocAlertEvent(
                          uid: barber.uid,
                          name: barber.barberName,
                          ventureName: barber.ventureName,
                        ),
                      );
                    }
                  },
                );
              },
              separatorBuilder:
                  (context, index) => ConstantWidgets.hight10(context),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unable to process the request.",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Please try again later. Refresh the page",
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () {
                    context.read<FetchBarberBloc>().add(FetchAllBarbersEvent());
                  },
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RequstBlocBuilder extends StatelessWidget {
  const RequstBlocBuilder({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestBloc, RequestState>(
      listener: (context, request) {
        requestStateHandle(context, request);
      },
      child: BlocBuilder<FetchBarberBloc, FetchBarberState>(
        builder: (context, state) {
          if (state is FetchBarberLoading) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: AppPalette.hintColor,
                      backgroundColor: AppPalette.blueColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPalette.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          } else if (State is FetchBarberEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "There's nothing here yet.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'No new request records are available yet.',
                    style: TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is FetchBarberLoaded) {
            final registedBarbers =
                state.barbers
                    .where((barber) => barber.isVerified == false)
                    .toList();
            if (registedBarbers.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "There's nothing here yet.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'No new request records are available yet.',
                      style: TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: registedBarbers.length,
              itemBuilder: (context, index) {
                final barber = registedBarbers[index];
                return RequestCardWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  barber: barber,
                  postive: 'Accept',
                  onPostive: () {
                    context.read<RequestBloc>().add(
                      AcceptAction(
                        name: barber.barberName,
                        id: barber.uid,
                        ventureName: barber.ventureName,
                      ),
                    );
                  },
                  negative: 'Reject',
                  onNegative: () {
                    context.read<RequestBloc>().add(
                      RejectAction(
                        name: barber.barberName,
                        id: barber.uid,
                        ventureName: barber.ventureName,
                      ),
                    );
                  },
                  time:
                      barber.createdAt != null
                          ? '${barber.createdAt!.day}:${barber.createdAt!.month}: ${barber.createdAt!.year}'
                          : 'N/A',
                );
              },
              separatorBuilder:
                  (context, index) => ConstantWidgets.hight10(context),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unable to process the request.",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Please try again later. Refresh the page",
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () {
                    context.read<FetchBarberBloc>().add(FetchAllBarbersEvent());
                  },
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RequestCardWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final BarberEntity barber;
  final String postive;
  final String? time;
  final Function() onPostive;
  final String negative;
  final Function() onNegative;

  const RequestCardWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barber,
    required this.postive,
    required this.onPostive,
    required this.negative,
    required this.onNegative,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromARGB(255, 242, 242, 242)),
      ),
      height: screenHeight * .18,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:
                      barber.image?.startsWith("http") ?? false
                          ? Image.network(
                            barber.image ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppPalette.blueColor,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              (loadingProgress
                                                      .expectedTotalBytes ??
                                                  1)
                                          : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppPalette.greyColor,
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            AppImages.appLogo,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),
                ),
              ),
            ),
            ConstantWidgets.width20(context),
            Flexible(
              flex: 4,
              child: SizedBox(
                width: screenWidth * 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barber.ventureName,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: AppPalette.blueColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        barber.barberName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        barber.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        barber.phoneNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        barber.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConstantWidgets.width20(context),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    color: AppPalette.whiteColor,
                    elevation: 2,

                    onSelected: (value) {
                      if (value == postive) {
                        onPostive();
                      } else if (value == negative) {
                        onNegative();
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          PopupMenuItem(value: postive, child: Text(postive)),
                          PopupMenuItem(value: negative, child: Text(negative)),
                        ],
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: AppPalette.greyColor,
                      ),
                    ),
                  ),
                  if (time != null)
                    Text(
                      time!,
                      style: TextStyle(
                        color: AppPalette.blackColor,
                        fontSize: 9,
                      ),
                    )
                  else if (barber.isVerified)
                    barber.isBloc
                        ? Text(
                          "Blocked",
                          style: TextStyle(color: AppPalette.redColor),
                        )
                        : Text(
                          'Active',
                          style: TextStyle(color: AppPalette.blueColor),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
