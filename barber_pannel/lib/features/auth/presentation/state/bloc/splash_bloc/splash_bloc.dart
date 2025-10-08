import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashScreenRequest>((event, emit) async{
        emit(GoToLogin());
    });
  }
}
