
import 'package:admin_pannel/features/presentation/screens/login_screen.dart';
import 'package:admin_pannel/features/presentation/screens/splash_screen.dart';
import 'package:admin_pannel/features/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login  = '/login_screen.dart';
  static const String dashboard = '/dashboard_screen.dart';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
      return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
      case dashboard:
      return MaterialPageRoute(builder: (_) => DashboardScreen());
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
