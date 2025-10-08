
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../data/datasource/auth_local_datasource.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthLocalDatasource authLocalDatasource;
  SplashBloc({required this.authLocalDatasource}) : super(SplashInitial()) {
    on<SplashScreenRequest>((event, emit) async{
      final bool isAdminLoggedIn = await authLocalDatasource.isAdminLoggedIn();
      if (isAdminLoggedIn) {
        emit(GoToHome());
      } else {
        emit(GoToLogin());
      }
    });
  }
}
