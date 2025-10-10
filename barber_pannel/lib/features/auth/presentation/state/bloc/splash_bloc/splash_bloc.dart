import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../data/datasource/auth_local_datasouce.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth auth;
  final AuthLocalDatasource localDB;
  SplashBloc({required this.auth, required this.localDB}) : super(SplashInitial()) {
    on<SplashScreenRequest>((event, emit) async{
       try {
           final String? id = await localDB.get();
           final currentUser = auth.currentUser;
        
        if(id != null && id.isNotEmpty && currentUser != null){
         emit(GoToHome());
        }else{
           emit(GoToLogin());
        }
       } catch (e) {
         emit(GoToLogin());
       }
    });
  }
}
