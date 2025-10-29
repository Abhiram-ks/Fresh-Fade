import 'package:client_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:client_pannel/features/app/data/model/booking_with_barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/barber_model.dart';
import '../model/booking_model.dart';

class BookingRemoteDatasource {
  final FirebaseFirestore firestore;
  final BarberService barberService;

  BookingRemoteDatasource({required this.firestore, required this.barberService});

  Future<bool> createBooking(BookingModel booking) async {
    try {
      final docRef = firestore.collection('bookings');
      final doc = await docRef.add(booking.toMap());

      return doc.id.isNotEmpty;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //Fetch bookings with barber
  Stream<List<BookingWithBarberModel>> allBooking({required String userId}) {
     try {
       return firestore
       .collection('bookings')
       .where('userId', isEqualTo: userId)
       .snapshots()
       .asyncMap<List<BookingWithBarberModel>>(barberService.attachBarbersToBookings);
     } catch (e) {
       throw Exception(e.toString());
     }
  }

  //Fetch bookings with barber filter
  Stream<List<BookingWithBarberModel>> getAllBookingFilter({required String userId, required String filter}) {
    try {
      return firestore
      .collection('bookings')
      .where('userId', isEqualTo: userId)
      .where('status', isEqualTo: filter)
      .snapshots()
      .asyncMap<List<BookingWithBarberModel>>(barberService.attachBarbersToBookings);
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // Fetch specific document
  Stream<BookingModel> getBookingById({required String bookingId}) {
    try {
     return firestore
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BookingModel.fromMap(snapshot.id, snapshot.data()!);
      } else {
        throw Exception("Booking documents does not exists");
      }
    });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}




class BarberService {
  final BarberRemoteDatasource barberDB;

  BarberService(this.barberDB);

  Future<List<BookingWithBarberModel>> attachBarbersToBookings(QuerySnapshot snapshot) async {
    final futures = snapshot.docs.map((doc) async {
      try {
        final BookingModel booking = BookingModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        final BarberModel barber = await barberDB.streamBarber(booking.barberId).first;
        return BookingWithBarberModel(booking: booking, barber: barber);
      } catch (e) {
        return null;
      }
    });

    final results = await Future.wait(futures);
    final validBookings = results.whereType<BookingWithBarberModel>().toList();
    validBookings.sort((a, b) => b.booking.createdAt.compareTo(a.booking.createdAt));
    return validBookings;
  }
}
