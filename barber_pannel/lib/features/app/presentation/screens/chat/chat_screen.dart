import 'package:flutter/material.dart';

import '../../../../../core/common/custom_appbar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Scaffold(
          appBar: CustomAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text('Home'),
              ],
            ),
          ),
        );
      },
    );
  }
}