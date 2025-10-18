import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_entity.dart';
import '../../../../../domain/usecase/stream_chats_usecase.dart';

part 'fetch_chat_barberlabel_event.dart';
part 'fetch_chat_barberlabel_state.dart';

class FetchChatBarberlabelBloc extends Bloc<FetchChatBarberlabelEvent, FetchChatBarberlabelState> {
  final AuthLocalDatasource localDB;
  final StreamChatsUseCase streamChatsUseCase;

  FetchChatBarberlabelBloc({
    required this.localDB,
    required this.streamChatsUseCase,
  }) : super(FetchChatBarberlabelInitial()) {
    on<FetchChatLebelBarberRequst>(_onFetchChatLebelBarberRequst);
    on<FetchChatLebelBarberSearch>(_onFetchChatLebelBarberSearch);
  }

  Future<void> _onFetchChatLebelBarberRequst(
    FetchChatLebelBarberRequst event,
    Emitter<FetchChatBarberlabelState> emit,
  ) async {
    emit(FetchChatBarberlebelLoading());
    try {
      final userID = await localDB.get();

      if (userID == null || userID.isEmpty) {
        emit(FetchChatBarberlebelFailure(error: 'Token expired. Please login again.'));
        return;
      }

      await emit.forEach<List<BarberEntity>>(
        streamChatsUseCase.call(userId: userID), 
        onData: (chat) {
          if (chat.isEmpty) {
            return FetchChatBarberlebelEmpty();
          } else {
            return FetchChatBarberlebelSuccess( barbers: chat,userID: userID);
          }
        },
           onError: (error, stackTrace) {
          return FetchChatBarberlebelFailure(error: error.toString());
        },
        );
    } catch (e) {
      emit(FetchChatBarberlebelFailure(error: e.toString()));
    }
  }


  Future<void> _onFetchChatLebelBarberSearch(
    FetchChatLebelBarberSearch event,
    Emitter<FetchChatBarberlabelState> emit,
  ) async {
    emit(FetchChatBarberlebelLoading());
    try {
    final userID = await localDB.get();
    if (userID == null || userID.isEmpty) {
        emit(FetchChatBarberlebelFailure(error: 'Token expired. Please login again.'));
        return;
    }
    await emit.forEach<List<BarberEntity>>(
      streamChatsUseCase.call(userId: userID),
      onData: (barbers){
           final filteredBarbers = barbers.where((barber) => barber.ventureName.toLowerCase().contains(event.query.toLowerCase())).toList();

        if (filteredBarbers.isEmpty) {
           return FetchChatBarberlebelEmpty();
        }else {
           return FetchChatBarberlebelSuccess( barbers: filteredBarbers,userID: userID);
        }
      },
       onError: (error, stackTrace) {
        return FetchChatBarberlebelFailure(error: error.toString());
      },
    );

    
    } catch (e) {
      emit(FetchChatBarberlebelFailure(error: e.toString()));
    }
  }
}
