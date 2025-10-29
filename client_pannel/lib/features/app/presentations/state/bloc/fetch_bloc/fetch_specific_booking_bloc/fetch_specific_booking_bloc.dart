import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/booking_entity.dart';
import '../../../../../domain/usecase/booking_usecase.dart';

part 'fetch_specific_booking_event.dart';
part 'fetch_specific_booking_state.dart';

class FetchSpecificBookingBloc extends Bloc<FetchSpecificBookingEvent, FetchSpecificBookingState> {
  final BookingUsecase bookingUsecase;
  FetchSpecificBookingBloc({required this.bookingUsecase}) : super(FetchSpecificBookingInitial()) {
    on<FetchSpecificBookingRequested>((event, emit) async {
     emit(FetchSpecificBookingLoading());
     try {
         await emit.forEach<BookingEntity>(
          bookingUsecase.getBookingById(bookingId: event.bookingId),
         onData: (booking) => FetchSpecificBookingLoaded(booking: booking),
         onError: (error, __) => FetchSpecificBookingFailure(error: error.toString()),
       );
     } catch (e) {
       emit(FetchSpecificBookingFailure(error: e.toString()));
     }
    });
  }
}
