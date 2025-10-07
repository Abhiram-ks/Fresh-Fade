part of 'radio_button_cubit.dart';

@immutable
abstract class RadioState  {}

final class RadioInitial extends RadioState {
  final String selectedOption;
  RadioInitial({this.selectedOption = 'Both'});
}

class RadioSelected extends RadioState {
  final String selectedOption;
  RadioSelected({required this.selectedOption});
}