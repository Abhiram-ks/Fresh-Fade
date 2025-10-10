import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/images/images.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/domain/entity/barber_entity.dart';
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
          return AdministrationBody(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          );
        },
      ),
    );
  }
}

class AdministrationBody extends StatefulWidget {
  const AdministrationBody({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<AdministrationBody> createState() => _AdministrationBodyState();
}

class _AdministrationBodyState extends State<AdministrationBody>
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
    child:  BlocBuilder<FetchBarberBloc, FetchBarberState>(
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
                    context.read<BlocandunblocBloc>()
                        .add(ShowUnBlacAlertEvent(
                          uid: barber.uid,
                          name: barber.barberName,
                          ventureName: barber.ventureName));
                  } else {
                    CustomSnackBar.show(context, 
                    message: "Account Alredy Active",
                    textAlign: TextAlign.center,
                    );
                  }
                },
                negative: 'Block',
                onNegative: () {
                  if (barber.isBloc) {
                    CustomSnackBar.show(context, 
                    message: "Account Alredy Suspended",
                    textAlign: TextAlign.center,
                    );
                  } else {
                      context.read<BlocandunblocBloc>()
                        .add(ShowBlocAlertEvent(
                          uid: barber.uid,
                          name: barber.barberName,
                          ventureName: barber.ventureName));
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
                    context.read<RequestBloc>().add(AcceptAction(
                        name: barber.barberName,
                        id: barber.uid,
                        ventureName: barber.ventureName));
                  },
                  negative: 'Reject',
                  onNegative: () {
                    context.read<RequestBloc>().add(RejectAction(
                        name: barber.barberName,
                        id: barber.uid,
                        ventureName: barber.ventureName));
                  },
                  time:
                      barber.createdAt != null
                          ? '${barber.createdAt!.day}:${barber.createdAt!.month}: ${barber.createdAt!.year}'
                          : 'N/A',
                );
              },
              separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
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
                width: screenWidth * 0.11,
                height: screenWidth * 0.11,
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
                          color: AppPalette.blueColor
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
