part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterPersonInfo extends RegisterEvent {
  final String name;
  final String venturename;
  final String phonNumber;
  final String address;
  RegisterPersonInfo({required this.name, required this.phonNumber, required this.venturename, required this.address,});
}

class RegisterCredential extends RegisterEvent {
  final String email;
  final String password;
  final bool isVerified;
  final bool isBloc;
  RegisterCredential({required this.email, required this.password, required this.isVerified, required this.isBloc});
}

class RegisterSubmit extends RegisterEvent {}