part of 'cod_payment_bloc.dart';

@immutable
abstract class CodPaymentState {}

final class CodPaymentInitial extends CodPaymentState {}
// online payment states slots available states
final class OnlinePaymentSlotAvailable extends CodPaymentState {}
// Online Payment state slots not available states
final class OnlinePaymentSlotNotAvailable extends CodPaymentState {}
// Online Payment state loading states
final class OnlinePaymentLoading extends CodPaymentState {}
// Online Payment state success states
final class OnlinePaymentSuccess extends CodPaymentState {}
// Online Payment state failure states
final class OnlinePaymentFailure extends CodPaymentState {
  final String error;
  OnlinePaymentFailure({required this.error});
}