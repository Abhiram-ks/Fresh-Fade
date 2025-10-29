import '../entity/barber_entity.dart';
import '../repo/wishlist_repo.dart';

class WishlistServiceUsecase {
  final WishlistRepo wishlistRepo;
  
  WishlistServiceUsecase({required this.wishlistRepo});
 
  //! add to wishlist
  Future<void> addLike({required String userId, required String barberId}) async {
    await wishlistRepo.addLike(userId: userId, barberId: barberId);
  }
  
  //! remove from wishlist
  Future<void> removeLike({required String userId, required String barberId}) async {
    await wishlistRepo.removeLike(userId: userId, barberId: barberId);
  }


  //! fetch single wishlist
  Stream<bool> fetchSingleWishlist({required String userId, required String barberId}) {
    return wishlistRepo.fetchSingleWishlist(userId: userId, barberId: barberId);
  }


  //! fetch all wishlists
  Stream<List<BarberEntity>> streamWishList({required String userId}) {
    return wishlistRepo.streamWishList(userId: userId);
  }
}