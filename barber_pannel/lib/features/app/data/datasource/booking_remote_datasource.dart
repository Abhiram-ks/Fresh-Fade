import 'package:barber_pannel/features/app/data/model/booking_model.dart';
import 'package:barber_pannel/features/app/data/model/booking_with_user_model.dart';
import 'package:barber_pannel/features/app/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_remote_datasource.dart';

class BookingRemoteDatasource {
  final FirebaseFirestore firebase;
  final UserServices userServices;

  BookingRemoteDatasource({required this.firebase, required this.userServices});

  Stream<List<BookingWithUserModel>> getBookings({
    required String barberID,
  }) {
    try {
      return firebase
      .collection('bookings')
      .where('barberId', isEqualTo: barberID)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .asyncMap((snapshot) => userServices.attachDocs(snapshot: snapshot));
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<BookingWithUserModel>> getFiltered({
    required String barberID,
    required String status,
  })  {
    try {
      return firebase
      .collection('bookings')
      .where('barberId', isEqualTo: barberID)
      .where('status', isEqualTo: status)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .asyncMap((snapshot) => userServices.attachDocs(snapshot: snapshot));
    } catch (e) {
      throw Exception(e);
    }
  }


  //. Fetch Specific Booking by docId
  Stream<BookingModel> getBookingByDocId({
    required String docId,
  })  {
    try {
        return firebase
        .collection('bookings')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BookingModel.fromMap(snapshot.id, snapshot.data()!);
      } else {
        throw Exception("Booking document not Exists!.");
      }
    });
    } catch (e) {
      throw Exception(e);
    }
  }

  //! Booking status update
  //! Update the booking status to the given status
  Future<bool> updateBookingStatus({
    required String docId,
    required String status,
    required String transactionStatus,
  }) async {
    try {
      await firebase.collection('bookings').doc(docId).update({
        'status': status,
        'transaction': transactionStatus,
      });

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
  
  //! Update All Timeouts to completed status changed 
  Future<bool> updateAllStatus({required String barberId}) async {
    try {
      final querySnapshot = await firebase
      .collection('bookings')
      .where('barberId', isEqualTo: barberId)
      .where('status', isEqualTo: 'timeout')
      .orderBy('createdAt', descending: true)
      .get();

      final batch = firebase.batch();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'status': 'completed',
          'transaction': 'completed',
        });
      }

      await batch.commit(); //? Commit All updates at once then return true
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }


  //! calcuate the total amount of the bookings
  /// After completed the booking the amount will be added to the wallet
  /// The amount will be calculated based on the booking amount
  
  Stream<double> calculateTotalAmount({required String barberId}) {
    try {
      return firebase
      .collection('bookings')
      .where('barberId', isEqualTo: barberId)
      .where('status', isEqualTo: 'completed')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((querySnapshot) {
        double total = 0.0;

        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          final serviceTypeRaw = data['serviceType'];

          if (serviceTypeRaw is Map) {
            serviceTypeRaw.forEach((_, value) {
              if (value is num) {
                total += value.toDouble();
              } else if (value is String) {
                final parsed = double.tryParse(value);
                if (parsed != null) total += parsed;
              }
            });
          }
        }

        return total;
      });
    } catch (e) {
      throw Exception(e);
    }
  }


  //! Fetch Individual User Bookings user userId
  /// return the bookings list with the user data
  Stream<List<BookingModel>> getIndividualUserBookings({required String userId, required String barberId}) {
    try {
      return firebase
      .collection('bookings')
      .where('userId', isEqualTo: userId)
      .where('barberId', isEqualTo: barberId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => BookingModel.fromMap(doc.id, doc.data())).toList();
      });
    } catch (e) {
        throw Exception(e);
    }
  }

  //! Fetch Individual User Bookings by status
  /// return the bookings list with the user data
  Stream<List<BookingModel>> getIndividualUserBookingsByStatus({required String userId, required String barberId, required String status}) {
    try {
      return firebase
      .collection('bookings')
      .where('userId', isEqualTo: userId)
      .where('barberId', isEqualTo: barberId)
      .where('status', isEqualTo: status)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => BookingModel.fromMap(doc.id, doc.data())).toList();
      });
    } catch (e) {
        throw Exception(e);
    }
  }

}

class UserServices {
  final UserRemoteDatasource datasource;

  UserServices({required this.datasource});

  Future<List<BookingWithUserModel>> attachDocs({
    required QuerySnapshot snapshot,
  }) async {
    final futures = snapshot.docs.map((doc) async {
      try {
        final BookingModel booking = BookingModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );

        final UserModel? user =  await datasource.streamUserData(userId: booking.userId).first;

        if (user != null) {
          return BookingWithUserModel(booking: booking, user: user);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    final validBookings = results.whereType<BookingWithUserModel>().toList();
    validBookings.sort(
      (a, b) => b.booking.createdAt.compareTo(a.booking.createdAt),
    );
    return validBookings;
  }
}
