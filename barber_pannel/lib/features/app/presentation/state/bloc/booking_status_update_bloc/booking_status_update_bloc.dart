import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecase/booking_usecase.dart';
part 'booking_status_update_event.dart';
part 'booking_status_update_state.dart';

class BookingStatusUpdateBloc extends Bloc<BookingStatusUpdateEvent, BookingStatusUpdateState> {
  final BookingUsecase bookingUsecase;
  String? docId;
  String? barberId;

  BookingStatusUpdateBloc({required this.bookingUsecase}) : super(BookingStatusUpdateInitial()) {

    //! Show Alert Box
    on<BookingStatusUpdateRequested>((event, emit) {
      docId = event.docId;
      barberId = event.barberId;
      emit(BookingStatusUpdateAlertBox(isAll: event.isAll));
    });

    //! Update Booking Status
    on<BookingStatusUpdateConfirmed>((event, emit) async{
      emit(BookingStatusUpdateLoading());
      try {
        
        final bool response = await bookingUsecase.updateBookingStatus(
          docId: docId ?? '', 
          status: 'completed', 
          transactionStatus: 'completed');
          if (response) {
            emit(BookingStatusUpdateSuccess());
          } else {
            emit(BookingStatusUpdateFailure(error: 'Failed to rewrite the booking docs from database'));
          }
      } catch (e) {
        emit(BookingStatusUpdateFailure(error: e.toString()));
      }
    });

    //! Update All Timeouts to completed status changed
    on<BookingStatusUpdatesAllTimeouts>((event, emit) async{
      emit(BookingStatusUpdateLoading());
      try {
        final bool response = await bookingUsecase.updateAllStatus(barberId: barberId ?? '');
        if (response) {
          emit(BookingStatusUpdateSuccess());
        } else {
          emit(BookingStatusUpdateFailure(error: 'Failed to rewrite the booking docs from database'));
        }
      } catch (e) {
        emit(BookingStatusUpdateFailure(error: e.toString()));
      }
    });
  }
}
