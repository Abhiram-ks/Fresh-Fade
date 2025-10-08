import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../data/datasource/auth_local_datasource.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthLocalDatasource authLocalDatasource;
  
  LogoutBloc({required this.authLocalDatasource}) : super(LogoutInitial()) {
    on<LogoutActionEvent>((event, emit) {
      emit(ShowLogoutDialogState());
    });

    on<ConfirmLogoutEvent>((event, emit) async {
      try {
        final bool response = await authLocalDatasource.clearAdminLogin();
        
        emit(response ? LogoutSuccessState() : LogoutFailureState('Log out failure'));
      } catch (e) {
         emit(LogoutFailureState('Log out failure due to: $e'));
      }
    
    });

  }
}
