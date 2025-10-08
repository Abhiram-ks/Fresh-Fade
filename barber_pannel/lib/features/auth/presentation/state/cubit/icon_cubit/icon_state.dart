part of 'icon_cubit.dart';

@immutable
abstract class IconState{}

final class IconInitial extends IconState {}

class ColorUpdated extends IconState {
  final Color color;
  ColorUpdated({required this.color});
}

class PasswordVisibilityUpdated extends IconState {
  final bool isVisible;

  PasswordVisibilityUpdated({required this.isVisible});
}