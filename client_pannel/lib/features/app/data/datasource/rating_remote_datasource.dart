import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RatingRemoteDataSource {
  final FirebaseFirestore firestore;
  RatingRemoteDataSource({required this.firestore});

  Future<double> fetchAverageRating(String barberId) async {
    final reviewSnapshot = await firestore
        .collection('reviews')
        .doc(barberId)
        .collection('shop_reviews')
        .get();

    final reviewData = reviewSnapshot.docs.map((e) => e.data()).toList();

    return compute(calculateAverage, reviewData);
  }
}



double calculateAverage(List<Map<String, dynamic>> reviews) {
  if (reviews.isEmpty) return 0.0;

  double totalStars = 0.0;
  for (var review in reviews) {
    if (review.containsKey('starCount')) {
      totalStars += (review['starCount'] as num).toDouble();
    }
  }

  return totalStars / reviews.length;
}
