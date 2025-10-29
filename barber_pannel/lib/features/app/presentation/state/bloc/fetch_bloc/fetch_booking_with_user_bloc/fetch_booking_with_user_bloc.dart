import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/model/booking_with_user_model.dart';

part 'fetch_booking_with_user_event.dart';
part 'fetch_booking_with_user_state.dart';

class FetchBookingWithUserBloc extends Bloc<FetchBookingWithUserEvent, FetchBookingWithUserState> {
  FetchBookingWithUserBloc() : super(FetchBookingWithUserInitial()) {
    on<FetchBookingWithUserRequested>((event, emit) {
      // TODO: implement event handler
    });
  }
}
