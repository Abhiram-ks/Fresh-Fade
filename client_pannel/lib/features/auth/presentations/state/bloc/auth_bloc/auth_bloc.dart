import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecase/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase authUsecase;
  AuthBloc({required this.authUsecase}) : super(AuthInitial()) {
    on<AuthSignInWithGoogleEvent>((event, emit) async{
      emit(AuthLoading());
      try {
        final String response = await authUsecase.signInwithGoogle();
        if (response.isEmpty) {
          emit(AuthFailure(error: 'Failed to sign in with Google'));
        } else {
          emit(AuthSuccess());
        }
      } on Exception catch (e) {
        emit(AuthFailure(error: e.toString()));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
