import 'package:barber_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../data/datasource/auth_local_datasouce.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth auth;
  final AuthLocalDatasource localDB;
  final GetBarberUseCase useCase;
  SplashBloc({required this.auth, required this.localDB, required this.useCase}) : super(SplashInitial()) {
    on<SplashScreenRequest>((event, emit) async{
       try {
           final String? id = await localDB.get();
           final currentUser = auth.currentUser;
        
        if(id != null && id.isNotEmpty && currentUser != null){
           final barber = await useCase(id).first;
           
           if(barber.isBloc == true){
             emit(GoToLogin());
           } else if(barber.isVerified == true){
             emit(GoToHome());
           } else {
             emit(GoToLogin());
           }
        }else{
           emit(GoToLogin());
        }
       } catch (e) {
         emit(GoToLogin());
       }
    });
  }
}
