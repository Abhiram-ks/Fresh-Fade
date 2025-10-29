part of 'cod_payment_bloc.dart';

@immutable
abstract class CodPaymentEvent {}

final class CodPaymentCheckSlots extends CodPaymentEvent {
  final String barberId;
  final List<SlotModel> selectedSlots;
  CodPaymentCheckSlots({required this.barberId, required this.selectedSlots});
}


final class CodPaymentCheckSlotsRequested extends CodPaymentEvent {
  final String barberId;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final double platformFee;
  final double bookingAmount;

  CodPaymentCheckSlotsRequested({required this.barberId, required this.selectedSlots, required this.selectedServices, required this.platformFee, required this.bookingAmount});
}