import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../widget/chat_widget/chat_body_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Scaffold(
          appBar: CustomAppBar2(
            isTitle: true,
            title: 'Chats',
            actions: [
              IconButton(
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder:
                          (_) => CupertinoAlertDialog(
                            title: Text('About Chats and chat windows'),
                            content: Text(
                              'Chats and chat windows enable seamless real-time communication with customers, allowing you to exchange messages, share media, and stay informed with live updates. The platform includes message indicators and badges for active conversations, ensuring you never miss important interactions or responses.',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Got it',
                                  style: TextStyle(
                                    color: AppPalette.buttonColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                },
                icon: Icon(Icons.help_outline_outlined),
              ),
            ],
          ),
          body: ChatScreenBodyWidget(  screenHeight: screenHeight, screenWidth: screenWidth),
        );
      },
    );
  }
}