import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../auth/data/datasource/auth_local_datasource.dart';
import '../../../../domain/entity/chat_entity.dart';
import '../../../../domain/usecase/get_last_message_usecase.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final GetLastMessageUsecase usecase;
  final AuthLocalDatasource localDB;
  StreamSubscription<ChatEntity?>? _subscription;

  LastMessageCubit({required this.usecase, required this.localDB}) : super(LastMessageInitial());

  void lastMessage({required String barberId}) async {
    emit(LastMessageLoading());

    _subscription?.cancel();

    final String? userId = await localDB.get();
    if (userId == null || userId.isEmpty) {
      emit(LastMessageFailure());
      return;
    }

    _subscription = usecase.call(userId, barberId)
        .listen((chat) {
      if (chat == null) {
        emit(LastMessageFailure());
      } else {
        emit(LastMessageSuccess(chat));
      }
    }, onError: (_) {
      emit(LastMessageFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
