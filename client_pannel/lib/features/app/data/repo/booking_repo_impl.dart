import 'package:client_pannel/features/app/data/model/booking_with_barber_model.dart';

import '../../domain/entity/booking_entity.dart';
import '../../domain/repo/booking_repo.dart';
import '../datasource/booking_remote_datasource.dart';
import '../model/booking_model.dart';

class BookingRepositoryImpl implements BookingRepo {
  final BookingRemoteDatasource bookingRemoteDatasource;

  BookingRepositoryImpl({required this.bookingRemoteDatasource});

  @override
  Future<bool> createBooking(BookingModel booking) async {
    try {
      return await bookingRemoteDatasource.createBooking(booking);
    } catch (e) {
      rethrow;
    }
  }

  //Fetch All Bookings with Barber
  @override
  Stream<List<BookingWithBarberModel>> getAllBooking({required String userId}) {
    try {
      return bookingRemoteDatasource.allBooking(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  //Fetch bookings with barber
  @override
  Stream<List<BookingWithBarberModel>> getAllBookingFilter({required String userId, required String filter}) {
    try {
      return bookingRemoteDatasource.getAllBookingFilter(userId: userId, filter: filter);
    } catch (e) {
      rethrow;
    }
  }

  // Fetch specific document
  @override
  Stream<BookingEntity> getBookingById({required String bookingId}) {
    try {
      return bookingRemoteDatasource.getBookingById(bookingId: bookingId);
    } catch (e) {
      rethrow;
    }
  }
}