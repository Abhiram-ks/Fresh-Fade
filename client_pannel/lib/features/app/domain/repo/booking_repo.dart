
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';

import '../../data/model/booking_model.dart';
import '../../data/model/booking_with_barber_model.dart';

abstract class BookingRepo {
  // Create a new booking
  // returns true if the booking is created successfully, otherwise false
  // throws an exception if any error occurs
  Future<bool> createBooking(BookingModel booking);

  //Fetch bookings with barber
  Stream<List<BookingWithBarberModel>> getAllBooking({required String userId});

  //Fetch bookings with barber filter
  Stream<List<BookingWithBarberModel>> getAllBookingFilter({required String userId, required String filter});

  // Fetch specific document
  Stream<BookingEntity> getBookingById({required String bookingId});
}