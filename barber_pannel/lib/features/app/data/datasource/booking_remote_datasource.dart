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
      .snapshots()
      .asyncMap((snapshot) => userServices.attachDocs(snapshot: snapshot));
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
