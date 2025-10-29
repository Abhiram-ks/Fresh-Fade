import '../../domain/entity/barber_entity.dart';
import '../../domain/repo/wishlist_repo.dart';
import '../datasource/wishlist_remote_datasource.dart';

class WishlistRepoImpl implements WishlistRepo {
  final WishlistRemoteDatasource wishlistRemoteDatasource;
  
  WishlistRepoImpl({required this.wishlistRemoteDatasource});

  @override
  Future<void> addLike({required String userId, required String barberId}) async {
    try {
      await wishlistRemoteDatasource.addLike(userId: userId, barberId: barberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  @override
  Future<void> removeLike({required String userId, required String barberId}) async {
    try {
      await wishlistRemoteDatasource.removeLike(userId: userId, barberId: barberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //! fetch single wishlist
  @override
  Stream<bool> fetchSingleWishlist({required String userId, required String barberId}) {
    try {
      return wishlistRemoteDatasource.fetchSingleWishlist(userId: userId, barberId: barberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<BarberEntity>> streamWishList({required String userId}) {
    try {
      return wishlistRemoteDatasource.streamWishList(userId: userId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}