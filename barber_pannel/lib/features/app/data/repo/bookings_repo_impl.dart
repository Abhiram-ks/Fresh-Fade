import 'package:barber_pannel/features/app/data/datasource/booking_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/repo/booking_repo.dart';

import '../../domain/entity/booking_entity.dart';
import '../model/booking_with_user_model.dart';

class BookingsRepoImpl implements BookingRepo {
  final BookingRemoteDatasource datasource;

  BookingsRepoImpl({required this.datasource});
  

  /// Get all bookings for a barber
  /// [barberID] - The ID of the barber
  /// Returns a stream of list of [BookingWithUserModel]
  @override
  Stream<List<BookingWithUserModel>> getBookings({required String barberID}) {
    return datasource.getBookings(barberID: barberID);
  }


  /// Get filtered bookings for a barber
  /// [barberID] - The ID of the barber
  /// [status] - The status of the bookings
  /// Returns a stream of list of [BookingWithUserModel]
  @override
  Stream<List<BookingWithUserModel>> getFiltered({required String barberID, required String status}) {
    return datasource.getFiltered(barberID: barberID, status: status);
  }

  /// Get specific booking by docId
  /// [docId] - The ID of the booking
  /// Returns a stream of [BookingEntity]
  @override
  Stream<BookingEntity> getBookingByDocId({required String docId}) {
    return datasource.getBookingByDocId(docId: docId);
  }

  //! Update booking status
  /// [docId] - The ID of the booking
  /// [status] - The status of the booking
  /// [transactionStatus] - The transaction status of the booking
  /// Returns a boolean
  @override
  Future<bool> updateBookingStatus({required String docId, required String status, required String transactionStatus}) {
    return datasource.updateBookingStatus(docId: docId, status: status, transactionStatus: transactionStatus);
  }

  //! Update all timeouts to completed status changed
  /// [barberId] - The ID of the barber
  /// Returns a boolean
  @override
  Future<bool> updateAllStatus({required String barberId}) {
    return datasource.updateAllStatus(barberId: barberId);
  }

  //! Calculate the total amount of the bookings
  /// [barberId] - The ID of the barber
  /// Returns a double
  @override
  Stream<double> calculateTotalAmount({required String barberId}) {
    return datasource.calculateTotalAmount(barberId: barberId);
  }

  //! Fetch Individual User Bookings
  /// [userId] - The ID of the user
  /// [barberId] - The ID of the barber
  /// Returns a stream of list of [BookingEntity]
  @override
  Stream<List<BookingEntity>> getIndividualUserBookings({required String userId, required String barberId}) {
    return datasource.getIndividualUserBookings(userId: userId, barberId: barberId);
  }

  //! Fetch Individual User Bookings by status
  /// [userId] - The ID of the user
  /// [barberId] - The ID of the barber
  /// [status] - The status of the bookings
  /// Returns a stream of list of [BookingEntity]
  @override
  Stream<List<BookingEntity>> getIndividualUserBookingsByStatus({required String userId, required String barberId, required String status}) {
    return datasource.getIndividualUserBookingsByStatus(userId: userId, barberId: barberId, status: status);
  }
}