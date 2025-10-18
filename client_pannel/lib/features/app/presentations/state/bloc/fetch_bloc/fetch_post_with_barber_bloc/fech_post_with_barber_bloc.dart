import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/model/post_with_barber_model.dart';
import 'package:client_pannel/features/app/domain/usecase/get_posts_with_barbers_usecase.dart';
import 'package:flutter/material.dart';

import '../../../../../../auth/data/datasource/auth_local_datasource.dart';

part 'fech_post_with_barber_event.dart';
part 'fech_post_with_barber_state.dart';

class FechPostWithBarberBloc extends Bloc<FechPostWithBarberEvent, FechPostWithBarberState> {
  final GetPostsWithBarbersUseCase getPostsWithBarbersUseCase;
  final AuthLocalDatasource localDB;
  FechPostWithBarberBloc({required this.getPostsWithBarbersUseCase, required this.localDB}) 
      : super(FechPostWithBarberInitial()) {
    on<FetchPostWithBarberRequest>(_onFetchPostWithBarberRequest);
  }

  Future<void> _onFetchPostWithBarberRequest(
    FetchPostWithBarberRequest event,
    Emitter<FechPostWithBarberState> emit,
  ) async {
    emit(FetchPostWithBarberLoading());

    try {
      final String? uid = await localDB.get();
      if (uid == null || uid.isEmpty) {
        emit(FetchPostWithBarberFailure(error: 'Token expired. Please login again.'));
        return;
      }

      await emit.forEach<List<PostWithBarberModel>>(
        getPostsWithBarbersUseCase(),
        onData: (posts) {
          if (posts.isEmpty) {
            return FetchPostWithBarberEmpty();
          } else {
            return FetchPostWithBarberLoaded(posts: posts, userId: uid);
          }
        },
        onError: (error, stackTrace) {
          return FetchPostWithBarberFailure(error: error.toString());
        },
      );
    } catch (e) {
      emit(FetchPostWithBarberFailure(error: e.toString()));
    }
  }
}
