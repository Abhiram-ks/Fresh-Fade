
import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';

import '../../data/model/booking_with_user_model.dart';

abstract class BookingRepo {
  /// Get all bookings for a barber
  Stream<List<BookingWithUserModel>> getBookings({required String barberID});

  /// Get filtered bookings for a barber
  Stream<List<BookingWithUserModel>> getFiltered({required String barberID, required String status});

  /// Get specific booking by docId
  Stream<BookingEntity> getBookingByDocId({required String docId});

  //! Update booking status
  Future<bool> updateBookingStatus({required String docId, required String status, required String transactionStatus});

  //! Update all timeouts to completed status changed
  Future<bool> updateAllStatus({ required String barberId});

  //! Calculate the total amount of the bookings
  Stream<double> calculateTotalAmount({required String barberId});

  //! Fetch Individual User Bookings
  Stream<List<BookingEntity>> getIndividualUserBookings({required String userId, required String barberId});

  //! Fetch Individual User Bookings by status
  Stream<List<BookingEntity>> getIndividualUserBookingsByStatus({required String userId, required String barberId, required String status});
}