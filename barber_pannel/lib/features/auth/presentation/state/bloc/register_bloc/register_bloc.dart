import 'dart:developer';

import 'package:barber_pannel/core/error/auth_exceptions.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterBarberUseCase usecase;
  String _fullName = '';
  String _ventureName = '';
  String _phoneNumber = '';
  String _address = ''; 
  String _email = '';
  String _password = '';
  bool _isVerified = false;
  bool _isBlok = false;

  String get fullName => _fullName;
  String get ventureName => _ventureName;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get email => _email;
  String get password => _password;
  bool get isVerified => _isVerified;
  bool get isBlok => _isBlok;
  
  RegisterBloc({required this.usecase}) : super(RegisterInitial()) {
    on<RegisterPersonInfo>((event, emit) {
      log('RegisterPersonInfo: ${event.name} ${event.venturename} ${event.phonNumber} ${event.address}');
      _fullName = event.name;
      _ventureName = event.venturename;
      _phoneNumber = event.phonNumber;
      _address = event.address;
    });

    on<RegisterCredential>((event, emit) {
      _email = event.email;
      _password = event.password;
      _isVerified = event.isVerified;
      _isBlok = event.isBloc;
      emit(RegisterAlertBoxState(name: _fullName, venturename: _ventureName, email: _email));
    });

    on<RegisterSubmit>((event, emit) async {
      emit(RegisterLoading());
      try {
        final response = await usecase.call(
          barberName: _fullName,
          ventureName: _ventureName,
          phoneNumber: _phoneNumber,
          address: _address,
          email: _email,
          password: _password,
          isBloc: _isBlok,
          isVerified: _isVerified,
        );

        if (response) {
          emit(RegisterSuccess());
        } else {
          emit(RegisterFailure(error: 'Registration failed. Please try again.'));
        }
      } on AuthException catch (e) {
        // Catch our custom exceptions with user-friendly messages
        log('Auth Exception: ${e.message}');
        emit(RegisterFailure(error: e.message));
      } catch (e) {
        // Catch any other unexpected errors
        log('Unknown Exception: $e');
        emit(RegisterFailure(error: 'An unexpected error occurred. Please try again.'));
      }
    });
  }
}
