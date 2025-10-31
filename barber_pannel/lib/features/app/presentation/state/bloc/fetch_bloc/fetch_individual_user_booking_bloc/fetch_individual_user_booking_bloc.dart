import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:barber_pannel/features/app/domain/usecase/booking_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'fetch_individual_user_booking_event.dart';
part 'fetch_individual_user_booking_state.dart';

class FetchIndividualUserBookingBloc extends Bloc<FetchIndividualUserBookingEvent, FetchIndividualUserBookingState> {
  final AuthLocalDatasource localDB;
  final BookingUsecase bookingUsecase;

  FetchIndividualUserBookingBloc({required this.localDB, required this.bookingUsecase}) : super(FetchIndividualUserBookingInitial()) {
    on<FetchIndividualUserBookingRequested>((event, emit) async{
      emit(FetchIndividualUserBookingLoading());

      try {
        final String? barberId = await localDB.get();
        if(barberId == null || barberId.isEmpty){
          emit(FetchIndividualUserBookingError(message: 'Token expired. Please login again.'));
          return;
        }
       
        await emit.forEach<List<BookingEntity>>(
          bookingUsecase.getIndividualUserBookings(userId: event.userId, barberId: barberId),
          onData: (bookings) => bookings.isEmpty
              ? FetchIndividualUserBookingEmpty()
              : FetchIndividualUserBookingSuccess(bookings: bookings),
          onError: (error, __) => FetchIndividualUserBookingError(message: error.toString()),
        );
      } catch (e) {
        emit(FetchIndividualUserBookingError(message: e.toString()));
      }
    });



    on<FetchIndividualUserBookingFiltered>((event, emit) async{
      emit(FetchIndividualUserBookingLoading());
      try {
        final String? barberId = await localDB.get();

        if(barberId == null || barberId.isEmpty){
          emit(FetchIndividualUserBookingError(message: 'Token expired. Please login again.'));
          return;
        }

        await emit.forEach<List<BookingEntity>>(
          bookingUsecase.getIndividualUserBookingsByStatus(userId: event.userId, barberId: barberId, status: event.status),
          onData: (bookings) => bookings.isEmpty
          ? FetchIndividualUserBookingEmpty()
          : FetchIndividualUserBookingSuccess(bookings: bookings),
          onError: (error, __) => FetchIndividualUserBookingError(message: error.toString()),
        );
      } catch (e) {
        emit(FetchIndividualUserBookingError(message: e.toString()));
      }
    });
  }
}