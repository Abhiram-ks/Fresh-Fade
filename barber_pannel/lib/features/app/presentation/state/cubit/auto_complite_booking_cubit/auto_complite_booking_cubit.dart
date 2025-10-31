import 'package:barber_pannel/features/app/domain/usecase/booking_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'auto_complite_booking_state.dart';

class AutoComplitedBookingCubit extends Cubit<AutoComplitedBookingState> {
 final BookingUsecase usecase;

  AutoComplitedBookingCubit({required this.usecase}) : super(AutoComplitedBookingInitial());

    Future<void> completeBooking(String docId) async {

    final success = await usecase.updateBookingStatus(
      docId: docId,
      status: 'timeout',
      transactionStatus: 'pending',
    );

    if (success) {
      emit(AutoComplitedBookingSuccess());
    } else {
      emit(AutoComplitedBookingFailure());
    }
  }
}
