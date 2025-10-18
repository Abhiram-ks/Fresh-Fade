import 'package:client_pannel/core/common/custom_appbar.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/widget/post_widget/posts_body_widget.dart';
import 'package:flutter/material.dart';


class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double heightFactor = 0.5;
    
        return Scaffold(
          appBar: CustomAppBar2(isTitle: true,title:'Social & Entertainment', titleColor: AppPalette.whiteColor,),
          body:PostScreenWidget(
                    screenHeight: screenHeight,
                    heightFactor: heightFactor,
                    screenWidth: screenWidth),
        );
      }
    );
  }
}