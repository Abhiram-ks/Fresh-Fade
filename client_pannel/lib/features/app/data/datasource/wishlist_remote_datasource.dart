import 'package:client_pannel/features/app/data/model/barber_model.dart';
import 'package:client_pannel/features/app/data/model/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'barber_remote_datasource.dart';

class WishlistRemoteDatasource {
  final FirebaseFirestore firestore;
  final BarberRemoteDatasource barberRemoteDatasource;

  WishlistRemoteDatasource({
    required this.firestore,
    required this.barberRemoteDatasource,
  });

  //! add to wishlist
  Future<void> addLike({
    required String userId,
    required String barberId,
  }) async {
    try {
      final docId = '${userId}_$barberId';
      final docRef = firestore.collection('wishlists').doc(docId);

      final data = WishlistModel(
        userId: userId,
        shopId: barberId,
        likedAt: DateTime.now(),
      );

      await docRef.set(data.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //! remove like
  Future<void> removeLike({
    required String userId,
    required String barberId,
  }) async {
    try {
      final docId = '${userId}_$barberId';
      final docRef = firestore.collection('wishlists').doc(docId);

      await docRef.delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //! fetch single wishlist
  Stream<bool> fetchSingleWishlist({
    required String userId,
    required String barberId,
  }) {
    try {
      final docId = '${userId}_$barberId';
      return firestore
          .collection('wishlists')
          .doc(docId)
          .snapshots()
          .map((snapshot) => snapshot.exists)
          .distinct();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //! fetch all wishlists
  Stream<List<BarberModel>> streamWishList({required String userId}) async* {
    try {
       yield* firestore
          .collection('wishlists')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .asyncMap((snapshot) async {
            final shopIds = snapshot.docs
              .map((doc) => doc['shopId'] as String?)
              .where((id) => id != null && id.trim().isNotEmpty)
              .cast<String>()
              .toList();

            if (shopIds.isEmpty) return [];

            final barberStreams = shopIds.map(
              (id) => barberRemoteDatasource.streamBarber(id).first,
            );
            final barbers = await Future.wait(barberStreams);
            return barbers;
          });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
