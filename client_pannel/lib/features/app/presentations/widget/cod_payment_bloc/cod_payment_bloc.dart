import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/foundation.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../../../../service/notification/notification_service.dart';
import '../../../data/model/booking_model.dart';
import '../../../data/model/slot_model.dart';
import '../../../domain/usecase/booking_usecase.dart';
import '../../../domain/usecase/get_slots_datas_usecase.dart';
part 'cod_payment_event.dart';
part 'cod_payment_state.dart';

class CodPaymentBloc extends Bloc<CodPaymentEvent, CodPaymentState> {
  final GetSlotsDatasUsecase getSlotsDatasUsecase;
  final AuthLocalDatasource localDB;
  final BookingUsecase bookingUsecase;

  CodPaymentBloc({required this.getSlotsDatasUsecase, required this.localDB, required this.bookingUsecase})
    : super(CodPaymentInitial()) {
    on<CodPaymentCheckSlots>(_handleCODPaymentChecking);
    on<CodPaymentCheckSlotsRequested>(_handleCODPaymentCheckingRequested);
  }

  Future<void> _handleCODPaymentChecking(
    CodPaymentCheckSlots event,
    Emitter<CodPaymentState> emit,
  ) async {
    emit(OnlinePaymentLoading());
    try {
      final bool isAvailable = await getSlotsDatasUsecase
          .checkSlotsAvailability(
            barberId: event.barberId,
            selectedSlots: event.selectedSlots,
          );

      if (isAvailable) {
        emit(OnlinePaymentSlotAvailable());
      } else {
        emit(OnlinePaymentSlotNotAvailable());
      }
    } catch (e) {
      emit(OnlinePaymentFailure(error: e.toString()));
    }
  }


  //! For COD Payment Checking Requested
  Future<void> _handleCODPaymentCheckingRequested(
    CodPaymentCheckSlotsRequested event,
    Emitter<CodPaymentState> emit,
  ) async {
    emit(OnlinePaymentLoading());
    
    try {
      final String? userId = await localDB.get();
      if (userId == null || userId.isEmpty) {
        emit(OnlinePaymentFailure(error: 'Token expired. Please login again.'));
        return;
      }
      
      final bool isAvailable = await getSlotsDatasUsecase.checkSlotsAvailability(barberId: event.barberId, selectedSlots: event.selectedSlots);

      if (!isAvailable) {
        log('Slot not available');
        emit(OnlinePaymentSlotNotAvailable());
        return;
      }

      final BookingModel booking = await createBookingModule(userId: userId, event: event); 

      final bool slotBooked = await getSlotsDatasUsecase.updateSlotsBooking(barberID: event.barberId, selectedSlots: event.selectedSlots);

      if (!slotBooked) {
        log('Slot Booking Failed. Slot not booked ${slotBooked}');
        emit(OnlinePaymentFailure(error: 'Slot Booking Failed. Sloteds re indicated.'));
        return;
      }
      
      final bool bookingCreated = await bookingUsecase.createBooking(booking);
      
      if (!bookingCreated) {
        emit(OnlinePaymentFailure(error: 'Booking Creation Failed. Please due to technical issues.'));
        return;
      }
       
      await NotificationService.showNotification(
        title: 'Booking Confirmation - Appointment Scheduled',
        body: 'Your appointment has been booked successfully. Booking ID: ${booking.bookingId}. Booking Code: ${booking.otp}.',
        payload: 'booking_success',
      );
      emit(OnlinePaymentSuccess());
    } catch (e) {
    emit(OnlinePaymentFailure(error: e.toString()));
    }
  }
} 



Future<BookingModel> createBookingModule({
  required String userId,
  required CodPaymentCheckSlotsRequested event,
}) async  {
  final String bookingOTP = GenerateBookingOtp().generateOtp();

   final Map<String, double> serviceTypeMap = {
    for (var item in event.selectedServices)
      item['serviceName']: (item['serviceAmount'] as num).toDouble(),
  };

  final List<DateTime> slotTimes = event.selectedSlots.map((slot) => slot.startTime).toList();
  final List<String> slotId = event.selectedSlots.map((id) => id.subDocId).toList();
  final String slotDate = event.selectedSlots.map((slotId) => slotId.docId).toList().first;

    final int totalDuration = event.selectedSlots
      .fold(0, (sum, slot) => sum + slot.duration.inMinutes);
  final DateTime date = parseSlotDocIdToDate(slotDate);


  return BookingModel(
    userId: userId,
    barberId: event.barberId,
    date: date,
    duration: totalDuration,
    paymentMethod: 'Cash on Hand',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    serviceType: serviceTypeMap,
    slotTime: slotTimes,
    slotId: slotId,
    slotDate: slotDate,
    amount: event.bookingAmount,
    platformFee: event.platformFee,
    status: 'pending',
    otp: bookingOTP,
    transaction: 'pending',
  );

}