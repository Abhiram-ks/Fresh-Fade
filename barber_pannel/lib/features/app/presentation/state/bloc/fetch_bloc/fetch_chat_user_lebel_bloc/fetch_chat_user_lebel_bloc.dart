import 'package:barber_pannel/features/app/domain/usecase/get_chat_users_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entity/user_entity.dart';

part 'fetch_chat_user_lebel_event.dart';
part 'fetch_chat_user_lebel_state.dart';


class FetchChatUserlebelBloc extends Bloc<FetchChatUserlebelEvent, FetchChatUserlebelState> {
  final AuthLocalDatasource localDB;
  final GetChatUsersUsecase usecase;
  FetchChatUserlebelBloc({required this.localDB, required this.usecase}) : super(FetchChatUserlebelInitial()) {
    on<FetchChatLebelUserRequst>(_onFetchchatWithUserRequest);
    on<FetchChatLebelUserSearch>(_onFetchchatwithBarberSerch);
  }
  

  Future<void> _onFetchchatWithUserRequest(
    FetchChatLebelUserRequst event,
    Emitter<FetchChatUserlebelState> emit,   
  ) async {  
    emit(FetchChatUserlebelLoading());
    try {
      final String? barberUid = await localDB.get();
      if (barberUid == null || barberUid.isEmpty) {
        emit(FetchChatUserlebelFailure());
        return;
      }

      await emit.forEach<List<UserEntity>>(
        usecase(barberId: barberUid), 
        onData: (chat) {
          if (chat.isEmpty) {
            return FetchChatUserlebelEmpty();
          } else {
            return FetchChatUserlebelSuccess(users:chat,barberId: barberUid);
          }
        },
           onError: (error, stackTrace) {
          return FetchChatUserlebelFailure();
        },
        );
    } catch (e) {
      emit(FetchChatUserlebelFailure());
    }
  }


  
  void _onFetchchatwithBarberSerch(
    FetchChatLebelUserSearch event,
    Emitter<FetchChatUserlebelState> emit,
  )async{
    emit(FetchChatUserlebelLoading());
    try {
      final String? barberUid = await localDB.get();
      if (barberUid == null || barberUid.isEmpty) {
        emit(FetchChatUserlebelFailure());
        return;
      }
      
      final searchQuery = event.searchController.trim().toLowerCase();
      
    await emit.forEach<List<UserEntity>>(
      usecase(barberId: barberUid),
      onData: (users){
        final filteredUsers = users.where((user) {
          final userName = user.name.toLowerCase();
          return userName.contains(searchQuery);
        }).toList();

        if (filteredUsers.isEmpty) {
           return FetchChatUserlebelEmpty();
        }else {
           return FetchChatUserlebelSuccess(users: filteredUsers, barberId: barberUid);
        }
      },
       onError: (error, stackTrace) {
        return FetchChatUserlebelFailure();
      },
    );
    } catch (e) {
      emit(FetchChatUserlebelFailure());
    }
  }

}
