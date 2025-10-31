import '../../data/model/booking_with_user_model.dart';
import '../entity/booking_entity.dart';
import '../repo/booking_repo.dart';

class BookingUsecase {
  final BookingRepo repo;

  BookingUsecase({required this.repo});

  /// Get all bookings for a barber
  /// [barberID] - The ID of the barber
  /// Returns a stream of list of [BookingWithUserModel]
  Stream<List<BookingWithUserModel>> getBookings({required String barberID}) {
    return repo.getBookings(barberID: barberID);
  }

  /// Get filtered bookings for a barber
  /// [barberID] - The ID of the barber
  /// [status] - The status of the bookings
  /// Returns a stream of list of [BookingWithUserModel]
  Stream<List<BookingWithUserModel>> getFiltered({required String barberID, required String status}) {
    return repo.getFiltered(barberID: barberID, status: status);
  }


  /// Get specific booking by docId
  /// [docId] - The ID of the booking
  /// Returns a stream of [BookingEntity]
  Stream<BookingEntity> getBookingByDocId({required String docId}) {
    return repo.getBookingByDocId(docId: docId);
  }


  //! Update booking status
  /// [docId] - The ID of the booking
  /// [status] - The status of the booking
  /// [transactionStatus] - The transaction status of the booking
  /// Returns a boolean
  Future<bool> updateBookingStatus({required String docId, required String status, required String transactionStatus}) {
    return repo.updateBookingStatus(docId: docId, status: status, transactionStatus: transactionStatus);
  }

  //! Update all timeouts to completed status changed
  /// [barberId] - The ID of the barber
  /// Returns a boolean
  Future<bool> updateAllStatus({required String barberId}) {
    return repo.updateAllStatus(barberId: barberId);
  }

  //! Calculate the total amount of the bookings
  /// [barberId] - The ID of the barber
  /// Returns a double
  Stream<double> calculateTotalAmount({required String barberId}) {
    return repo.calculateTotalAmount(barberId: barberId);
  }

  //! Fetch Individual User Bookings
  /// [userId] - The ID of the user
  /// [barberId] - The ID of the barber
  /// Returns a stream of list of [BookingEntity]
  Stream<List<BookingEntity>> getIndividualUserBookings({required String userId, required String barberId}) {
    return repo.getIndividualUserBookings(userId: userId, barberId: barberId);
  }

  //! Fetch Individual User Bookings by status
  /// [userId] - The ID of the user
  /// [barberId] - The ID of the barber
  /// [status] - The status of the bookings
  /// Returns a stream of list of [BookingEntity]
  Stream<List<BookingEntity>> getIndividualUserBookingsByStatus({required String userId, required String barberId, required String status}) {
    return repo.getIndividualUserBookingsByStatus(userId: userId, barberId: barberId, status: status);
  }
}