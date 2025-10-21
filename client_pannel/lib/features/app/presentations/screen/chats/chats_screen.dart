import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/nav_cubit/nav_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_appbar.dart';
import '../../widget/chat_widget/chat_body_widget.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar2(
                title: 'Chats',
                isTitle: true,
                titleColor: AppPalette.whiteColor,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.help_outline_rounded,
                      color: AppPalette.whiteColor,
                    ),
                  ),
                  ConstantWidgets.width20(context),
                ],
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ChatScreenBodyWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.read<ButtomNavCubit>().selectItem(NavItem.search);
                },
                backgroundColor: AppPalette.orengeColor,
                child: const Icon(
                  CupertinoIcons.chat_bubble_text,
                  color: AppPalette.whiteColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
