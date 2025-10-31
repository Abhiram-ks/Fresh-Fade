
import 'package:barber_pannel/features/app/presentation/screens/chat/chat_windows.dart';
import 'package:barber_pannel/features/app/presentation/screens/home/notification_screen/notification_screen.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/post_screen/post_screen.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/profile_screen.dart';
import 'package:barber_pannel/features/auth/presentation/screen/password_screen.dart';
import 'package:barber_pannel/features/auth/presentation/screen/register_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../features/app/presentation/screens/chat/user_detail_view.dart';
import '../../features/app/presentation/screens/home/wallet_screen/wallet_screen.dart';
import '../../features/app/presentation/screens/nav_screen.dart';
import '../../features/app/presentation/screens/setting/booking_management_screen/booking_management_screen.dart';
import '../../features/app/presentation/screens/setting/individual_booking_screen/individual_booking_screen.dart';
import '../../features/app/presentation/screens/setting/service_manage/service_add_screen.dart';
import '../../features/app/presentation/screens/setting/time_manage/time_management.dart' show TimeManagementScreen;
import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/screen/map_screen.dart';
import '../../features/auth/presentation/screen/register_detail_screen.dart';
import '../../features/app/presentation/screens/setting/service_manage/service_manage_screen.dart';
import '../../features/auth/presentation/screen/splash_screen.dart';
import '../constant/constant.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login = '/login_screen.dart';
  static const String register = '/register_detail_screen.dart';
  static const String registerCredential = '/register_credential.dart';
  static const String map = '/map_screen.dart';
  static const String nav = '/nav_cubit.dart';
  static const String profile = '/profile_screen.dart';
  static const String password = '/password_screen.dart';
  static const String serviceManage = '/service_manage_screen.dart';
  static const String serviceAdd = '/service_add_screen.dart';
  static const String timeManagement = '/time_management.dart';
  static const String chatWindows = '/chat_windows';
  static const String post = '/post_screen';
  static const String userProfile = '/user_detail_view';
  static const String bookingManagement = '/booking_management_screen';
  static const String notification = '/notification_screen';
  static const String wallet = '/wallet_screen';
  static const String individualBooking = '/individual_booking_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
      return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
      return CupertinoPageRoute(builder: (_) => RegisterDetailsScreen());
      case registerCredential:
      return CupertinoPageRoute(builder: (_) => RegisterCredentialsScreen());
      case map:
      final addressController = settings.arguments as TextEditingController;
      return MaterialPageRoute(builder: (_) => LocationMapPage(
        addressController: addressController,
      ));
      case profile:
      final isShow = settings.arguments as bool;
      return CupertinoPageRoute(builder: (_) => ProfileScreen(isShow: isShow));
      case nav:
      return CupertinoPageRoute(builder: (_) => BottomNavigationControllers());
      case password:
      final isWhat = settings.arguments as bool;
      return CupertinoPageRoute(builder: (_) => PasswordScreen(
        isWhat: isWhat,
      ));
      case serviceManage:
      return CupertinoPageRoute(builder: (_) => ServiceManageScreen());
      case serviceAdd:
      return CupertinoPageRoute(builder: (_) => ServiceAddScreen());
      case timeManagement:
      return CupertinoPageRoute(builder: (_) => TimeManagementScreen());
      case chatWindows:
      final arguments  = settings.arguments as Map<String, dynamic>;
      final userId = arguments['userId'] as String;
      final barberId = arguments['barberId'] as String;
      return MaterialPageRoute(builder: (_) => ChatWindowsScreen(userId: userId, barberId: barberId));
      case post:
      return MaterialPageRoute(builder: (_) => PostScreen());
      case userProfile:
      final userId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => UserProfileScreen(userId: userId));
      case bookingManagement:
      return CupertinoPageRoute(builder: (_) => BookingManagementScreen());
      case notification:
      return MaterialPageRoute(builder: (_) => NotifcationScreen());
      case wallet:
      return MaterialPageRoute(builder: (_) => WalletScreen());
      case individualBooking:
      final userId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => IndivitualBookingScreen(userId: userId));
      default:
        return MaterialPageRoute(
          builder:
              (_) => LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;

                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .04,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Page Not Found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           ConstantWidgets.hight20(context),
                            Text(
                              'The page you were looking for could not be found. '
                              'It might have been removed, renamed, or does not exist.',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
    }
  }
}
