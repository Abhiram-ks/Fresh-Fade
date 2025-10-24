import 'dart:io';

import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/chat_model.dart';
import '../../../../domain/usecase/send_message_usecase.dart';
part 'send_message_event.dart';
part 'send_message_state.dart';


class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendMessageUsecase usecase;
  final CloudinaryService cloudinaryService;

  SendMessageBloc({
    required this.usecase,
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
      senderId: event.barberId,
      barberId: event.barberId,
      userId: event.userId,
      message: event.message,
      createdAt: now,
      updatedAt: now,
      isSee: false,
      delete: false,
      softDelete: false,
    );

    final success = await usecase.sendMessage(message: message);
    emit(success ? SendMessageSuccess() : SendMessageFailure());
  }

  Future<void> _onSendImageMessage(
    SendImageMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    try {
      
       
        final String? response  = await cloudinaryService.uploadImage(File(event.image));
       
      

      if (response == null || response.isEmpty) {
        emit(SendMessageFailure());
        return;
      }
      

      final now = DateTime.now();
      final message = ChatModel(
        senderId: event.barberId,
        barberId: event.barberId,
        userId: event.userId,
        message: response,
        createdAt: now,
        updatedAt: now,
        isSee: false,
        delete: false,
        softDelete: false,
      );

      final success = await usecase.sendMessage(message: message);
      emit(success ? SendMessageSuccess() : SendMessageFailure());
    } catch (_) {
      emit(SendMessageFailure());
    }
  }
}
