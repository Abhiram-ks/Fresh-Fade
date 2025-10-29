import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/repo/calcel_booking_repository.dart';
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../service/notification/notification_service.dart';
import '../../../../domain/usecase/get_slots_datas_usecase.dart';
part 'cancel_booking_event.dart';
part 'cancel_booking_state.dart';

class CancelBookingBloc extends Bloc<CancelBookingEvent, CancelBookingState> {
  final CancelBookingRepository cancelBookingRepository;
  final GetSlotsDatasUsecase getSlotsDatasUsecase;

  CancelBookingBloc({required this.cancelBookingRepository, required this.getSlotsDatasUsecase}) : super(CancelBookingInitial()) {
    on<BookingOTPChecking>((event, emit) {
      if (event.bookingOTP == event.inputOTP) {
        emit(BookingOTPMachingTrue());
      } else {
        emit(BookingOTPMachingfalse());
      }
    });

    on<BookingCancelOTPChecked>((event, emit) async  {
      emit(BookingOTPMachingLoading());

      try {
        final BookingEntity booking = event.booking;

        final startTime = booking.slotTime.isNotEmpty
          ? (List<DateTime>.from(booking.slotTime)..sort()).first
          : null;

        if (startTime == null) {
          emit(BookingOTPMachingFailure(error: 'Invalid booking slot time'));
          return;
        }
        
 
        final bool result = await getSlotsDatasUsecase.cancelSlots(barberId: booking.barberId, docId: booking.slotDate, slotId: booking.slotId);

        if (result) {
           final bool response = await cancelBookingRepository.updateBookingStatus(docId: booking.bookingId ?? '', status: 'cancelled', transactionStatus: 'cancelled' );

           if (response == false) {
             emit(BookingOTPMachingFailure(error: 'Booking cancellation failed'));
             return;
           }

           await NotificationService.showNotification(title: 'Booking Cancelled Successfully', body: 'Your appointment has been cancelled. We hope to serve you again soon.', payload: 'booking_cancelled successfully');
           emit(BookingCancelCompleted());
        } else {
          emit(BookingOTPMachingFailure(error: 'Booking cancellation failed'));
          return;
        } 
      } catch (e) {
        emit(BookingOTPMachingFailure(error: e.toString()));
      }
    });
  }
}
