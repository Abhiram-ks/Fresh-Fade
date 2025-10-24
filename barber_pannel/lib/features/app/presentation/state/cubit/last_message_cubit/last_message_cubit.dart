import 'dart:async';

import 'package:barber_pannel/features/app/domain/usecase/chat_labels_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entity/chat_entity.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final ChatLabelsUsecase usecase;
  final AuthLocalDatasource localDB;
  StreamSubscription<ChatEntity?>? _subscription;

  LastMessageCubit({required this.usecase, required this.localDB}) : super(LastMessageInitial());

   lastMessage({required String userId}) async {
    if (isClosed) return;
    emit(LastMessageLoading());

    _subscription?.cancel();
    final String? barberUid = await localDB.get();
    if (barberUid == null || barberUid.isEmpty) {
      if (!isClosed) emit(LastMessageFailure());
      return;
    }

    _subscription = usecase
        .call(userId: userId, barberId: barberUid)
        .listen((chat) {
      if (isClosed) return;
      if (chat == null) {
        emit(LastMessageFailure());
      } else {
        emit(LastMessageSuccess(chat));
      }
    }, onError: (_) {
      if (!isClosed) emit(LastMessageFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
