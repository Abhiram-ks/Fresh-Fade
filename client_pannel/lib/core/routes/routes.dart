import 'package:client_pannel/features/app/presentations/screen/settings/map_screen/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/app/presentations/screen/chats/chat_window.dart';
import '../../features/app/presentations/screen/nav.screen.dart';
import '../../features/app/presentations/screen/search/detail_screen/detail_barber_screen.dart';
import '../../features/app/presentations/screen/settings/profile_screen/profile_screen.dart';
import '../../features/auth/presentations/screen/login_screen.dart';
import '../../features/auth/presentations/screen/splash_screen.dart';
import '../constant/constant.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login_screen';
  static const String nav = '/nav.screen';
  static const String profile = '/profile_screen';
  static const String map = '/map_screen';
  static const String detailBarber = '/detail_barber_screen';
  static const String chatWindow = '/chat_window';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case nav:
        return MaterialPageRoute(builder: (_) => BottomNavigationControllers());
      case profile:
        bool isShow = settings.arguments as bool;
        return CupertinoPageRoute(
          builder: (_) => ProfileEditDetails(isShow: isShow),
        );
      case map:
        final addressController = settings.arguments as TextEditingController;
        return CupertinoPageRoute(
          builder: (_) => LocationMapPage(addressController: addressController),
        );
      case detailBarber:
        final barberId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailBarberScreen(barberID: barberId),
        );
      case chatWindow:
        final args = settings.arguments as Map<String, dynamic>;
        final barberId = args['barberId'] as String;
        final userId = args['userId'] as String;
        return MaterialPageRoute(
          builder: (_) => ChatWindow(barberId: barberId, userId: userId),
        );
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
