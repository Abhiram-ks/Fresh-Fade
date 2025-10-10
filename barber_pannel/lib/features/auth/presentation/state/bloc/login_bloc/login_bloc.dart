import 'package:barber_pannel/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginBarberUseCase usecase;

  LoginBloc({required this.usecase}) : super(LoginInitial()) {
    on<LoginActionEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final barber = await usecase.call(
          email: event.email,
          password: event.password,
        );
        
        
        if (barber.isBloc == true) {
          emit(LoginBlocShop());
        } else if (barber.isVerified == true) {
          emit(LoginSuccess());
        } else {
          emit(LoginNotVerified());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-not-verified') {
          emit(LoginEmailNotVarify(email: event.email));
        } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          emit(LoginFailure(error: 'Incorrect Email or Password. Please try again'));
        } else if (e.code == 'too-many-requests') {
          emit(LoginFailure(error: 'Too many requests. Please try again later'));
        } else if (e.code == 'network-request-failed') {
          emit(LoginFailure(error: 'Network Error. Please check your internet connection'));
        } else {
          emit(LoginFailure(error: 'An Error Occurred: ${e.message}'));
        }
      }  catch (e, _) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
