import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthLocalDatasource localDB;
  SplashBloc({required this.localDB}) : super(SplashInitial()) {
    on<SplashScreenRequest>((event, emit) async{
      try {
       final String? uid = await localDB.get();
       if(uid == null || uid.isEmpty){
        emit(GoToLogin());
       }else{
        emit(GoToHome());
       }
      } catch (e) {
        emit(GoToLogin()
        );
      } 
    });
  }
}
