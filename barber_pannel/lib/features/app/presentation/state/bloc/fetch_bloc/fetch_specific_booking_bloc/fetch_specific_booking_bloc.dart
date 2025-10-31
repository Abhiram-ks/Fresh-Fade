import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/usecase/booking_usecase.dart';
part 'fetch_specific_booking_event.dart';
part 'fetch_specific_booking_state.dart';

class FetchSpecificBookingBloc extends Bloc<FetchSpecificBookingEvent, FetchSpecificBookingState> {
  final BookingUsecase bookingUsecase;  
  FetchSpecificBookingBloc({required this.bookingUsecase}) : super(FetchSpecificBookingInitial()) {
    on<FetchSpecificBookingRequested>((event, emit) async {
      emit(FetchSpecificBookingLoading());

      try { 
        await emit.forEach <BookingEntity> (
        bookingUsecase.getBookingByDocId(docId: event.docId), onData: (booking) {
          return FetchSpecificBookingSuccess(booking: booking);
        }, onError: (error, stackTrace) {
          return FetchSpecificBookingError(error: error.toString());
        });
      } catch (e) {
        emit(FetchSpecificBookingError(error: e.toString()));
      }
    });
  }
}
