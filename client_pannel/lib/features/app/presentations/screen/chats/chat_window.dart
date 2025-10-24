
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/chat_window/chat_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_chat_window_textfiled.dart';
import '../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../state/bloc/send_message_bloc/send_message_bloc.dart';
import '../../state/cubit/status_chat_request_cubit/status_chat_request_cubit.dart';
import '../../widget/chat_window/chat_window_widget.dart';

class ChatWindow extends StatefulWidget {
  final String barberId;
  final String userId;
  const ChatWindow({super.key, required this.barberId, required this.userId});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchAbarberBloc>()),
        BlocProvider(create: (context) => sl<ImagePickerBloc>()),
        BlocProvider(create: (context) => sl<StatusChatRequstDartCubit>()),
        BlocProvider(create: (context) => sl<SendMessageBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => EmojiPickerCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              appBar: ChatAppBar(
                barberId: widget.barberId,
                screenWidth: screenWidth,
              ),
              body: ChatWindowWidget(
                userId: widget.userId,
                barberId: widget.barberId,
                controller: controller,
              ),
            ),
          );
        },
      ),
    );
  }
}
