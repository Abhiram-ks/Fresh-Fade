import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../domain/usecase/password_usecase.dart';
part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordUsecase passwordUsecase;
  String email = '';

  PasswordBloc({required this.passwordUsecase}) : super(PasswordInitial()) {
    on<PasswordRequestedEvent>((event, emit) {
      email = event.email;
      emit(PasswordAlertBoxState(email: event.email));
    });

    on<PasswordConfirmationEvent>((event, emit) async {
      emit(PasswordLoadingState());

      try {
        // Step 1: Verify email exists in database
        final bool isVerified = await passwordUsecase.verifyPasswordResetEmail(email);
        
        if (!isVerified) {
          emit(PasswordErrorState(message: 'No account found with this email address'));
          return;
        }

        // Step 2: Send password reset email
        final bool isSent = await passwordUsecase.sendPasswordResetEmail(email);
        
        if (isSent) {
          emit(PasswordSuccessState());
        } else {
          emit(PasswordErrorState(message: 'Failed to send password reset email'));
        }
      } on Exception catch (e) {
        // Clean up error message
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(PasswordErrorState(message: errorMessage));
      } catch (e) {
        emit(PasswordErrorState(message: 'An unexpected error occurred. Please try again.'));
      }
    });
  }
}
