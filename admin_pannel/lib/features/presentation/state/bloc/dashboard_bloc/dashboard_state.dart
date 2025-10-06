abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;

  DashboardLoaded({required this.data});
}

class DashboardRefreshing extends DashboardState {
  final DashboardData data;

  DashboardRefreshing({required this.data});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

class DashboardData {
  final int totalUsers;
  final int totalAppointments;
  final double totalRevenue;
  final int activeBarbers;
  final int todayAppointments;
  final double weeklyGrowth;
  final double monthlyGrowth;
  final List<String> recentActivities;

  DashboardData({
    required this.totalUsers,
    required this.totalAppointments,
    required this.totalRevenue,
    required this.activeBarbers,
    required this.todayAppointments,
    required this.weeklyGrowth,
    required this.monthlyGrowth,
    required this.recentActivities,
  });
}