import 'package:barber_pannel/features/app/domain/usecase/booking_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/model/booking_with_user_model.dart';

part 'fetch_booking_with_user_event.dart';
part 'fetch_booking_with_user_state.dart';

class FetchBookingWithUserBloc
    extends Bloc<FetchBookingWithUserEvent, FetchBookingWithUserState> {
  final BookingUsecase usecase;
  final AuthLocalDatasource localDB;
  FetchBookingWithUserBloc({required this.usecase, required this.localDB})
    : super(FetchBookingWithUserInitial()) {
    on<FetchBookingWithUserRequested>((event, emit) async {
      emit(FetchBookingWithUserLoading());

      try {
        final String? barberID = await localDB.get();

        if (barberID == null) {
          emit(FetchBookingWithUserError(message: 'Token expired. Please login again.'));
          return;
        }

        await emit.forEach<List<BookingWithUserModel>>(
          usecase.getBookings(barberID: barberID),
          onData: (bookings) {
            if (bookings.isEmpty) {
              return FetchBookingWithUserEmpty();
            }
            return FetchBookingWithUserSuccess(bookings: bookings);
          },
          onError: (error, __) {
            return FetchBookingWithUserError(message: error.toString());
          },
        );
      } catch (e) {
        emit(FetchBookingWithUserError(message: e.toString()));
      }
    });

    on<FetchBookingWithUserFilteredRequested>((event, emit) async {
      emit(FetchBookingWithUserLoading());

      try {
        final String? barberID = await localDB.get();
        if (barberID == null) {
          emit(FetchBookingWithUserError(message: 'Token expired. Please login again.'));
          return;
        }

        await emit.forEach<List<BookingWithUserModel>>(
          usecase.getFiltered(barberID: barberID, status: event.status),
          onData: (bookings) {
            if (bookings.isEmpty) {
              return FetchBookingWithUserEmpty();
            }
            return FetchBookingWithUserSuccess(bookings: bookings);
          },
          onError: (error, stackTrace) {
            return FetchBookingWithUserError(message: error.toString());
          },
        );
      }catch (e) {
        emit(FetchBookingWithUserError(message: e.toString()));
      }
    });
  }
}
