import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock dashboard data
      final dashboardData = DashboardData(
        totalUsers: 1250,
        totalAppointments: 340,
        totalRevenue: 25600.0,
        activeBarbers: 15,
        todayAppointments: 25,
        weeklyGrowth: 12.5,
        monthlyGrowth: 8.3,
        recentActivities: [
          'New user registered: John Doe',
          'Appointment booked by Sarah Wilson',
          'Payment received: \$150',
          'Barber Alex completed service',
          'New review submitted: 5 stars',
        ],
      );
      
      emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    // Keep current state while refreshing
    if (state is DashboardLoaded) {
      final currentData = (state as DashboardLoaded).data;
      emit(DashboardRefreshing(data: currentData));
    }
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock updated dashboard data
      final dashboardData = DashboardData(
        totalUsers: 1255, // Updated values
        totalAppointments: 342,
        totalRevenue: 25750.0,
        activeBarbers: 15,
        todayAppointments: 27,
        weeklyGrowth: 13.2,
        monthlyGrowth: 8.8,
        recentActivities: [
          'New user registered: Emma Smith',
          'Appointment booked by Mike Johnson',
          'Payment received: \$200',
          'Barber Lisa completed service',
          'New review submitted: 4 stars',
        ],
      );
      
      emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}