import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:flutter/material.dart';

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
                onPressed: () {},
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