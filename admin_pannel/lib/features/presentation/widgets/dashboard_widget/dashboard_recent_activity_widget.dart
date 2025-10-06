import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardRecentActivityWidget extends StatelessWidget {
  const DashboardRecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded || state is DashboardRefreshing) {
          final data = state is DashboardLoaded 
              ? state.data 
              : (state as DashboardRefreshing).data;
          
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.blackColor.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.blackColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<DashboardBloc>().add(RefreshDashboardData());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppPalette.blueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.refresh,
                          color: AppPalette.blueColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                ConstantWidgets.hight15(context),
                ...data.recentActivities.asMap().entries.map(
                  (entry) => _buildActivityItem(
                    context,
                    entry.value,
                    entry.key == 0, // First item is most recent
                  ),
                ).toList(),
                ConstantWidgets.hight10(context),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full activity log
                    },
                    child: Text(
                      'View All Activities',
                      style: GoogleFonts.poppins(
                        color: AppPalette.blueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, String activity, bool isRecent) {
    IconData icon;
    Color iconColor;
    
    // Determine icon based on activity content
    if (activity.contains('user registered') || activity.contains('User registered')) {
      icon = Icons.person_add_outlined;
      iconColor = Colors.green;
    } else if (activity.contains('Appointment') || activity.contains('appointment')) {
      icon = Icons.event_outlined;
      iconColor = Colors.blue;
    } else if (activity.contains('Payment') || activity.contains('payment')) {
      icon = Icons.payment_outlined;
      iconColor = Colors.orange;
    } else if (activity.contains('completed') || activity.contains('Completed')) {
      icon = Icons.check_circle_outline;
      iconColor = Colors.purple;
    } else if (activity.contains('review') || activity.contains('Review')) {
      icon = Icons.star_outline;
      iconColor = Colors.amber;
    } else {
      icon = Icons.info_outline;
      iconColor = AppPalette.greyColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          ConstantWidgets.width12(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppPalette.blackColor,
                    fontWeight: isRecent ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                Text(
                  isRecent ? 'Just now' : '${DateTime.now().difference(DateTime.now().subtract(Duration(minutes: 5 + (activity.hashCode % 60)))).inMinutes} min ago',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppPalette.greyColor,
                  ),
                ),
              ],
            ),
          ),
          if (isRecent)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}