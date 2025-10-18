import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/barber_model.dart';
import 'rating_remote_datasource.dart';

class BarberRemoteDatasource {
  final FirebaseFirestore firestore; 
  final RatingRemoteDataSource ratingService;
  BarberRemoteDatasource({required this.firestore, required this.ratingService});


  Stream<List<BarberModel>> streamAllBarbers() {
    try {
        return firestore
        .collection('barbers')
        .orderBy('ventureName')
        .where('isVerified', isEqualTo:  true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      final barbers = await Future.wait(querySnapshot.docs.map((doc) async {
        try {
          final rating = await ratingService.fetchAverageRating(doc.id);
          return BarberModel.fromMap(doc.data(),doc.id, rating, );
        } catch (e) {
          return null;
        }
      }));
      return barbers.whereType<BarberModel>().toList();
    }).handleError((e) {
      throw Exception(e.toString());
    });
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Stream<BarberModel> streamBarber(String barberId) {
    try {
    return firestore
        .collection('barbers')
        .doc(barberId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.exists) {
        try {
          final rating = await ratingService.fetchAverageRating(barberId);
          return BarberModel.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.id,rating);
        } catch (e) {
          log('Error with rating: $e');
          rethrow;
        }
      } else {
        throw Exception('Barber not found');
      }
    }).handleError((error) {
      throw Exception(error.toString());
    });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}