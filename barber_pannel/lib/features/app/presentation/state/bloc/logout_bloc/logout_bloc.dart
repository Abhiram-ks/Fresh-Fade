import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final FirebaseAuth auth;
  final AuthLocalDatasource localDB;
  LogoutBloc({required this.localDB, required this.auth}) : super(LogoutInitial()) {
    on<LogoutRequestEvent>((event, emit) {
      emit(LogoutAlertState());
    });
    on<LogoutConfirmEvent>((event, emit) async {
      try {
        await localDB.clean();
        await auth.signOut();
        emit(LogoutSuccessState());
      } catch (e) {
        emit(LogoutErrorState(error: "logout failed : ${e.toString()}"));
      }
    });
  }
}
