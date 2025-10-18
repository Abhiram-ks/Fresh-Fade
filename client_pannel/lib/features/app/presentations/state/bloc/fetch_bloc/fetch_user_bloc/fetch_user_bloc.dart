import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entity/user_entity.dart';
import '../../../../../domain/usecase/user_usecase.dart';

part 'fetch_user_event.dart';
part 'fetch_user_state.dart';

class FetchUserBloc extends Bloc<FetchUserEvent, FetchUserState> {
  final UserUsecase userUsecase;
  final AuthLocalDatasource localDB;


  FetchUserBloc({required this.userUsecase, required this.localDB}) : super(FetchUserInitial()) {
    on<FetchUserStarted>(_onFetchUserStarted);
  }

  Future<void> _onFetchUserStarted(
    FetchUserStarted event,
    Emitter<FetchUserState> emit,
  ) async {
    emit(FetchUserLoading());

    try {
      final String? uid = await localDB.get();

      if (uid == null || uid.isEmpty) {
        emit(FetchUserFailure(error: 'Token expired. Please login again.'));
        return;
      }
      
      await emit.forEach<UserEntity>(
        userUsecase.getUserStream(uid),
        onData: (user) => FetchUserLoaded(user: user),
        onError: (error, stackTrace) => FetchUserFailure(error: error.toString()),
      );
    } catch (e) {
      emit(FetchUserFailure(error: e.toString()));
    }
  }
}

