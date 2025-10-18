import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/data/datasource/auth_local_datasource.dart';
import '../../../../domain/usecase/send_comment_usecase.dart';

part 'send_comment_event.dart';
part 'send_comment_state.dart';

class SendCommentBloc extends Bloc<SendCommentEvent, SendCommentState> {
  final SendCommentUseCase sendCommentUseCase;
  final AuthLocalDatasource localDB;

  SendCommentBloc({
    required this.sendCommentUseCase,
    required this.localDB,
  }) : super(SendCommentInitial()) {
    on<SendCommentButtonPressed>(_sendComment);
  }

  Future<void> _sendComment(
    SendCommentButtonPressed event,
    Emitter<SendCommentState> emit,
  ) async {
    emit(SendCommentLoading());
    try {
      final String? userId = await localDB.get();

      if (userId == null || userId.isEmpty) {
        emit(SendCommentFailure(error: 'Token expired. Please login again.'));
        return;
      }

      final success = await sendCommentUseCase(
        userId: userId,
        comment: event.comment,
        docId: event.docId,
        barberId: event.barberId,
      );

      if (success) {
        emit(SendCommentSuccess());
      } else {
        emit(SendCommentFailure(error: "Comment Delivered Failure!"));
      }
    } catch (error) {
      emit(SendCommentFailure(error: error.toString()));
    }
  }
}
