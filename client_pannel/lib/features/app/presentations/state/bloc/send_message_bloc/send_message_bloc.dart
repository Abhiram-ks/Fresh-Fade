import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/domain/usecase/send_chat_usecasde.dart';
import 'package:flutter/material.dart';

import '../../../../../../service/cloudinary/cloudinary_service.dart';
import '../../../../data/model/chat_model.dart';
part 'send_message_event.dart';
part 'send_message_state.dart';


class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendChatUsecase sendChatUsecase;
  final CloudinaryService cloudinaryService;

  SendMessageBloc({
    required this.sendChatUsecase,
    required this.cloudinaryService,
  }) : super(SendMessageInitial()) {
    on<SendTextMessage>(_onSendTextMessage);
    on<SendImageMessage>(_onSendImageMessage);
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    final now = DateTime.now();
    final message = ChatModel(
      senderId: event.userId,
      barberId: event.barberId,
      userId: event.userId,
      message: event.message,
      createdAt: now,
      updatedAt: now,
      isSee: false,
      delete: false,
      softDelete: false,
    );

    final success = await sendChatUsecase.call(message: message);
    emit(success ? SendMessageSuccess() : SendMessageFailure());
  }

  Future<void> _onSendImageMessage(
    SendImageMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    try {
      final uploadedImageUrl = await cloudinaryService.uploadImage(File(event.image));

      if (uploadedImageUrl == null) {
        emit(SendMessageFailure());
        return;
      }
      

      final now = DateTime.now();
      final message = ChatModel(
        senderId: event.userId,
        barberId: event.barberId,
        userId: event.userId,
        message: uploadedImageUrl,
        createdAt: now,
        updatedAt: now,
        isSee: false,
        delete: false,
        softDelete: false,
      );

      final success = await sendChatUsecase.call(message: message);
      emit(success ? SendMessageSuccess() : SendMessageFailure());
    } catch (_) {
      emit(SendMessageFailure());
    }
  }
}
