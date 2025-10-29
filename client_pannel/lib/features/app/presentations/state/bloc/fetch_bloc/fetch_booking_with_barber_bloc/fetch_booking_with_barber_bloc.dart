import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/model/booking_with_barber_model.dart';
import 'package:client_pannel/features/app/domain/usecase/booking_usecase.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/material.dart';

part 'fetch_booking_with_barber_event.dart';
part 'fetch_booking_with_barber_state.dart';

class FetchBookingWithBarberBloc extends Bloc<FetchBookingWithBarberEvent, FetchBookingWithBarberState> {
  final AuthLocalDatasource localDB;
  final BookingUsecase bookingusecase;
  FetchBookingWithBarberBloc({required this.localDB, required this.bookingusecase}) : super(FetchBookingWithBarberInitial()) {
    on<FetchBookingWithBarberRequest>((event, emit) async{
      emit(FetchBookingWithBarberLoading());
      try {
        final String? uid = await localDB.get();

        if (uid == null || uid.isEmpty) {
          emit(FetchBookingWithBarberFailure(error: 'Token expired. Please login again.'));
          return;
        }

        await emit.forEach<List<BookingWithBarberModel>>(
          bookingusecase.getAllBooking(userId: uid),
          onData: (bookings) {
            if (bookings.isEmpty) {
              return FetchBookingWithBarberEmpty();
            } else {
              return FetchBookingWithBarberSuccess(bookings: bookings);
            }
          }, onError: (error, stackTrace) {
            return FetchBookingWithBarberFailure(error: error.toString());
          });
      } catch (e) {
        emit(FetchBookingWithBarberFailure(error: e.toString()));
      }
    });

   on<FetchBookingWithBarberFilter>((event, emit) async{
    emit(FetchBookingWithBarberLoading());
    try {
      final String? uid = await localDB.get();
      if (uid == null || uid.isEmpty) {
        emit(FetchBookingWithBarberFailure(error: 'Token expired. Please login again.'));
        return;
      }

      await emit.forEach<List<BookingWithBarberModel>>(
        bookingusecase.getAllBookingFilter(userId: uid, filter: event.filter),
        onData: (bookings) {
          if (bookings.isEmpty) {
            return FetchBookingWithBarberEmpty();
          } else {
            return FetchBookingWithBarberSuccess(bookings: bookings);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingWithBarberFailure(error: error.toString());
        },
      );
    }catch (e) {
      emit(FetchBookingWithBarberFailure(error: e.toString()));
    }
  });
  }


}
