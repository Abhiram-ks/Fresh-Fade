import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/repo/calcel_booking_repository.dart';
import 'package:flutter/foundation.dart';
part 'auto_completed_booking_state.dart';

class AutoComplitedBookingCubit extends Cubit<AutoComplitedBookingState> {
 final CancelBookingRepository cancelBookingRepository;

  AutoComplitedBookingCubit(this.cancelBookingRepository) : super(AutoComplitedBookingInitial());

    Future<void> completeBooking(String docId) async {

    final success = await cancelBookingRepository.updateBookingStatus(
      docId: docId,
      status: 'timeout',
      transactionStatus: 'debited',
    );

    if (success) {
      emit(AutoComplitedBookingSuccess());
    } else {
      emit(AutoComplitedBookingFailure());
    }
  }
}
