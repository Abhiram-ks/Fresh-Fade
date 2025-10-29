part of 'fetch_single_wishlist_cubit.dart';

@immutable
abstract class FetchSingleWishlistState {}

final class FetchSingleWishlistInitial extends FetchSingleWishlistState {}

class FetchWishlistSinglebarberLoaded  extends  FetchSingleWishlistState{
  final bool isLiked;

  FetchWishlistSinglebarberLoaded(this.isLiked);
}