import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/dashboard_widget/dashboard_stats_widget.dart';
import 'package:admin_pannel/features/presentation/widgets/dashboard_widget/dashboard_header_widget.dart';
import 'package:admin_pannel/features/presentation/widgets/dashboard_widget/dashboard_recent_activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboardData()),
      child: ColoredBox(
        color: AppPalette.blueColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            appBar: AppBar(
              backgroundColor: AppPalette.blueColor,
              elevation: 0,
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.whiteColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Add notification functionality
                  },
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: AppPalette.whiteColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add profile functionality
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: AppPalette.whiteColor,
                  ),
                ),
                ConstantWidgets.width10(context),
              ],
            ),
            body: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.blueColor,
                    ),
                  );
                }
                
                if (state is DashboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppPalette.greyColor,
                        ),
                        ConstantWidgets.hight20(context),
                        Text(
                          'Error loading dashboard',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppPalette.greyColor,
                          ),
                        ),
                        ConstantWidgets.hight10(context),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DashboardBloc>().add(LoadDashboardData());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.blueColor,
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.poppins(
                              color: AppPalette.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return const DashboardBody();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeaderWidget(),
          ConstantWidgets.hight20(context),
          const DashboardStatsWidget(),
          ConstantWidgets.hight20(context),
          const DashboardRecentActivityWidget(),
          ConstantWidgets.hight20(context),
        ],
      ),
    );
  }
}