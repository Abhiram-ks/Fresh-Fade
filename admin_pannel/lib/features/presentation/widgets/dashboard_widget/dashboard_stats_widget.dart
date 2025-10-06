import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardStatsWidget extends StatelessWidget {
  const DashboardStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded || state is DashboardRefreshing) {
          final data = state is DashboardLoaded 
              ? state.data 
              : (state as DashboardRefreshing).data;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.blackColor,
                ),
              ),
              ConstantWidgets.hight15(context),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard(
                    context,
                    'Total Users',
                    data.totalUsers.toString(),
                    Icons.people_outline,
                    AppPalette.blueColor,
                    '+${data.weeklyGrowth.toStringAsFixed(1)}%',
                  ),
                  _buildStatCard(
                    context,
                    'Appointments',
                    data.totalAppointments.toString(),
                    Icons.calendar_today_outlined,
                    Colors.green,
                    '+${data.monthlyGrowth.toStringAsFixed(1)}%',
                  ),
                  _buildStatCard(
                    context,
                    'Revenue',
                    '\$${data.totalRevenue.toStringAsFixed(0)}',
                    Icons.attach_money_outlined,
                    Colors.orange,
                    'This month',
                  ),
                  _buildStatCard(
                    context,
                    'Active Barbers',
                    data.activeBarbers.toString(),
                    Icons.content_cut_outlined,
                    Colors.purple,
                    'Online now',
                  ),
                ],
              ),
            ],
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppPalette.blackColor.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Icon(
                Icons.more_vert,
                color: AppPalette.greyColor,
                size: 16,
              ),
            ],
          ),
          ConstantWidgets.hight10(context),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppPalette.blackColor,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppPalette.greyColor,
            ),
          ),
          ConstantWidgets.hight5(context),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}