
import '../entity/barber_entity.dart';

abstract class WishlistRepo {
 //! add to wishlist
  Future<void> addLike({required String userId, required String barberId});

  //! remove from wishlist
  Future<void> removeLike({required String userId, required String barberId});

  //! fetch single wishlist
  Stream<bool> fetchSingleWishlist({required String userId, required String barberId});

  //! fetch all wishlists
  Stream<List<BarberEntity>> streamWishList({required String userId});
}