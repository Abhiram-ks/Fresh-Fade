part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

final class SplashInitial extends SplashState {}
final class GoToLogin extends SplashState {}
final class GoToHome  extends SplashState {}
