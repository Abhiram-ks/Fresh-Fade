import 'package:client_pannel/features/app/presentations/state/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/chat_window/chat_handle_send_message_state.dart';
import 'package:client_pannel/features/app/presentations/widget/chat_window/chat_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/custom_chat_window_textfiled.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../data/model/chat_model.dart';
import '../../../domain/entity/chat_entity.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/cubit/status_chat_request_cubit/status_chat_request_cubit.dart';
import 'message_buble_widget.dart';

class ChatWindowWidget extends StatefulWidget {
  final String userId;
  final String barberId;
  final TextEditingController controller;

  const ChatWindowWidget({
    super.key,
    required this.userId,
    required this.barberId,
    required this.controller,
  });

  @override
  State<ChatWindowWidget> createState() => _ChatWindowWidgetState();
}

class _ChatWindowWidgetState extends State<ChatWindowWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;

  @override
  void initState() {
    super.initState();
    context.read<StatusChatRequstDartCubit>().updateChatStatus(
      userId: widget.userId,
      barberId: widget.barberId,
    );
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isAtBottom =
        _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200;

    _shouldAutoScroll = isAtBottom;
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  Stream<List<ChatEntity>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chat')
        .where('userId', isEqualTo: widget.userId)
        .where('barberId', isEqualTo: widget.barberId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatEntity>>(
            stream: getMessagesStream(),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? [];
              if (_shouldAutoScroll) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });
              }
              if (snapshot.hasData && _scrollController.hasClients) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => scrollToBottom(),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.orengeColor,
                          backgroundColor: AppPalette.hintColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (messages.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidgets.hight50(context),
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppPalette.buttonColor.withAlpha(
                            (0.3 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '⚿ No conversations yet.Your chats are private and end-to-end encrypted. Only you and your barber can read them. Start a conversation now and enjoy seamless, secure messaging!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppPalette.blackColor),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool showDateLabel =
                      index == 0 ||
                      messages[index - 1].createdAt.day !=
                          message.createdAt.day;

                  return Column(
                    children: [
                      if (showDateLabel)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppPalette.hintColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(message.createdAt),
                                style: const TextStyle(
                                  color: AppPalette.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      MessageBubleWidget(
                        message: message.message,
                        time: DateFormat('hh:mm a').format(message.createdAt),
                        isCurrentUser: message.senderId == widget.userId,
                        docId: message.docId ?? '',
                        delete: message.delete == true,
                        softDelete:
                            message.senderId == widget.userId &&
                            message.softDelete == true,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        imagePIckerChating(),
        BlocListener<SendMessageBloc, SendMessageState>(
          listener: (context, state) {
            handleSendMessage(context, state, widget.controller);
          },
          child: ChatWindowTextFiled(
            controller: widget.controller,
            sendButton: () {
              final text = widget.controller.text.trim();
              final imageState = context.read<ImagePickerBloc>().state;

              if (imageState is ImagePickerLoaded) {
                final imagePath = imageState.imagePath;
                context.read<SendMessageBloc>().add(SendImageMessage(
                    image: imagePath,
                    userId: widget.userId,
                    barberId: widget.barberId));
              }
              if (text.isEmpty) return;

              context.read<SendMessageBloc>().add(
                    SendTextMessage(
                      message: text,
                      userId: widget.userId,
                      barberId: widget.barberId,
                    ),
                  );
              Future.delayed(const Duration(milliseconds: 1), () {
                scrollToBottom();
              });
            },
          ),
        ),
      ],
    );
  }
}
