import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../auth/data/datasource/auth_local_datasource.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final AuthLocalDatasource localDB;
  LogoutBloc({required this.localDB, required this.auth, required this.googleSignIn}) : super(LogoutInitial()) {
    on<LogoutRequestEvent>((event, emit) {
      emit(LogoutAlertState());
    });
    on<LogoutConfirmEvent>((event, emit) async {
       emit(LogoutLoadingState());
      try {
       
    
        final response = await localDB.delete();
        if (!response) {
          emit(LogoutErrorState(error: 'Failed to clear local token storage.'));
          return;
        }
      
        await auth.signOut();
        
        await googleSignIn.signOut();
        
        emit(LogoutSuccessState());
      } on FirebaseAuthException catch (e) {
        emit(LogoutErrorState(error: 'Firebase sign out error: ${e.message}'));
      } on Exception catch (e) {
        emit(LogoutErrorState(error: 'Logout error: ${e.toString()}'));
      } catch (e) {
        emit(LogoutErrorState(error: 'Unexpected error: ${e.toString()}'));
      }
    });
  }
}
