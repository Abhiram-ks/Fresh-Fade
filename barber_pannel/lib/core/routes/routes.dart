
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/screen/map_screen.dart';
import '../../features/auth/presentation/screen/register_detail_screen.dart';
import '../../features/auth/presentation/screen/splash_screen.dart';
import '../constant/constant.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login = '/login_screen.dart';
  static const String register = '/register_detail_screen.dart';
  static const String map = '/map_screen.dart';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
      return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
      return MaterialPageRoute(builder: (_) => RegisterDetailsScreen());
      case map:
        final addressController = settings.arguments as TextEditingController;
      return MaterialPageRoute(builder: (_) => LocationMapPage(
        addressController: addressController,
      ));
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
