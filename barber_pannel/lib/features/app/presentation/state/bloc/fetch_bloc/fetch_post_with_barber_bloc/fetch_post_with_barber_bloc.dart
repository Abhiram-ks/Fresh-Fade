import 'package:barber_pannel/features/app/data/model/post_with_barber_model.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/usecase/get_post_with_barber_usecase.dart';

part 'fetch_post_with_barber_event.dart';
part 'fetch_post_with_barber_state.dart';

class FetchPostWithBarberBloc extends Bloc<FetchPostWithBarberEvent, FetchPostWithBarberState> {
  final GetPostWithBarberUsecase usecase; 
  final AuthLocalDatasource localDB;
  FetchPostWithBarberBloc({required this.usecase, required this.localDB}) : super(FetchPostWithBarberInitial()) {
    on<FetchPostWithBarberRequested>((event, emit) async{
     emit(FetchPostWithBarberLoading());
     try {
       final String? barberID = await localDB.get();
       if (barberID == null) {
        emit(FetchPostWithBarberError(message: 'Token Expired. Please login again.'));
        return;
       }
       
       await emit.forEach(
        usecase.call(barberID),
        onData: (posts) {
          if (posts.isEmpty) {
            return FetchPostWithBarberEmpty();
          }
          return FetchPostWithBarberLoaded(posts: posts);
        }, onError: (error, stackTrace) {
          return FetchPostWithBarberError(message: error.toString());
        });
      } catch (e) {
        emit(FetchPostWithBarberError(message: e.toString()));
      }
    });
  }
}
