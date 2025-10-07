import 'package:admin_pannel/features/domain/usecase/login_admin_usecase.dart';
import 'package:admin_pannel/service/security/hash_password.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginAdminUseCase loginAdminUseCase;

  LoginBloc({required this.loginAdminUseCase}) : super(LoginInitial()) {
    on<LoginRequest>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final String adminHashPassword = hashPassword(event.password);
      final success = await loginAdminUseCase.execute(
        email: event.email,
        password: adminHashPassword,
      );

      emit(success
          ? LoginSuccess()
          : LoginFailure(error: "Invalid email or password"));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
