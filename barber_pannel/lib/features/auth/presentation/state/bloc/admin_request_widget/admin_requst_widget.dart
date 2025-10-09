import 'package:flutter/material.dart';


import '../../../../../../core/themes/app_colors.dart';
import '../../../screen/admin_request_screen.dart';
  
void navigateToAdminRequest(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) => AdminRequest(),
        transitionsBuilder: (_, animation, __, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
               ColoredBox(color: AppPalette.buttonColor),
              ScaleTransition(
                scale: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutQuad),
                ),
                child: FadeTransition(opacity: animation, child: child),
              ),
            ],
          );
        },
      ),
    );
  }


