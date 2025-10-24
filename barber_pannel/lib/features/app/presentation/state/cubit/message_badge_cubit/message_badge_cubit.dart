import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/data/datasource/auth_local_datasouce.dart';
import '../../../../domain/usecase/chat_labels_usecase.dart';

part 'message_badge_state.dart';

class MessageBadgeCubit extends Cubit<MessageBadgeState> {
  final ChatLabelsUsecase usecase;  
  final AuthLocalDatasource authLocalDatasource;
  StreamSubscription<int>? _subscription;

  MessageBadgeCubit({required this.usecase, required this.authLocalDatasource}) : super(MessageBadgeInitial());

  numberOfBadges({
    required String userId,
  }) async {
    if (isClosed) return;
    emit(MessageBadgeLoading());

    _subscription?.cancel();
    final String? barberUid = await authLocalDatasource.get();
    if (barberUid == null || barberUid.isEmpty) {
      if (!isClosed) emit(MessageBadgeFailure());
      return;
    }
    _subscription = usecase
    .execute(userId: userId, barberId: barberUid)
        .listen((count) {
      if (isClosed) return;
      if (count == 0) {
        emit(MessageBadgeEmpty());
      } else {
        emit(MessageBadgeSuccess(count));
      }
    }, onError: (_) {
      if (!isClosed) emit(MessageBadgeFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
