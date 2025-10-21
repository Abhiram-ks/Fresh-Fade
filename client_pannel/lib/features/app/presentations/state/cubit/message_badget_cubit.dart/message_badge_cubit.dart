import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecase/get_message_badge_usecase.dart';
part 'message_badge_state.dart';


class MessageBadgeCubit extends Cubit<MessageBadgeState> {
  final AuthLocalDatasource localDB;
  final GetMessageBadgeUsecase usecase;
  StreamSubscription<int>? _subscription;

  MessageBadgeCubit({required this.localDB, required this.usecase}) : super(MessageBadgeInitial());

   numberOfBadges({
    required String barberId,
  }) async{
    emit(MessageBadgeLoading());

    _subscription?.cancel();
    final String? userId = await localDB.get();
    if (userId == null || userId.isEmpty) {
      return MessageBadgeFailure('Token expired. Please login again.');
    }

    _subscription = usecase.call(userId, barberId)
        .listen((count) {
      if (count == 0) {
        emit(MessageBadgeEmpty());
      } else {
        emit(MessageBadgeSuccess(count));
      }
    }, onError: (e) {
      emit(MessageBadgeFailure(e.toString()));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
