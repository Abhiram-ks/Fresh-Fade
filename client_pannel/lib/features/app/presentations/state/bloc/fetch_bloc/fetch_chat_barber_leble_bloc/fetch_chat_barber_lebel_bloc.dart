import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_entity.dart';
import '../../../../../domain/usecase/get_strem_chat_usecase.dart';

part 'fetch_chat_barber_lebel_event.dart';
part 'fetch_chat_barber_lebel_state.dart';

class FetchChatBarberlebelBloc extends Bloc<FetchChatBarberlebelEvent, FetchChatBarberlebelState> {
  final AuthLocalDatasource localDB;
  final GetStremChatUseCase usecase;
  FetchChatBarberlebelBloc({required this.localDB,required this.usecase}) : super(FetchChatBarberlebelInitial()) {
    on<FetchChatLebelBarberRequst>(_onFetchchatwithBarberRequst);
    on<FetchChatLebelBarberSearch>(_onFetchchatwithBarberSerch);
  }

  Future<void> _onFetchchatwithBarberRequst(
    FetchChatLebelBarberRequst event,
    Emitter<FetchChatBarberlebelState> emit,   
  ) async {  
    emit(FetchChatBarberlebelLoading());
    try {
      final String? userId = await localDB.get();
      if (userId == null || userId.isEmpty) {
        emit(FetchChatBarberlebelFailure());
        return;
      }
      
      await emit.forEach<List<BarberEntity>>(
        usecase.call(userId: userId), 
        onData: (chat) {
          if (chat.isEmpty) {
            return FetchChatBarberlebelEmpty();
          } else {
            return FetchChatBarberlebelSuccess(chat,userId);
          }
        },
           onError: (error, stackTrace) {
          return FetchChatBarberlebelFailure();
        },
        );
    } catch (e) {
      emit(FetchChatBarberlebelFailure());
    }
  }

  void _onFetchchatwithBarberSerch(
    FetchChatLebelBarberSearch event,
    Emitter<FetchChatBarberlebelState> emit,
  )async{
    emit(FetchChatBarberlebelLoading());
    final String? userId = await localDB.get();
      
      if (userId == null || userId.isEmpty) {
        emit(FetchChatBarberlebelFailure());
        return;
      }
    await emit.forEach<List<BarberEntity>>(
      usecase.call(userId: userId),
      onData: (barbers){
        final filteredBarbers = barbers.where((barber) => barber.ventureName.toLowerCase().contains(event.searchController.toLowerCase())).toList();

        if (filteredBarbers.isEmpty) {
           return FetchChatBarberlebelEmpty();
        }else {
           return FetchChatBarberlebelSuccess(filteredBarbers,userId);
        }
      },
       onError: (error, stackTrace) {
        return FetchChatBarberlebelFailure();
      },
    );

  }

}
