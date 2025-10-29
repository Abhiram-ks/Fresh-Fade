part of 'fetch_wishlist_bloc.dart';

@immutable
abstract class FetchWishlistState {}

final class FetchWishlistInitial extends FetchWishlistState {}

final class FetchWishlistLoading extends FetchWishlistState {}

final class FetchWishlistEmpty extends FetchWishlistState {}

final class FetchWishlistSuccess extends FetchWishlistState {
  final List<BarberEntity> wishlists;
  FetchWishlistSuccess({required this.wishlists});
}

final class FetchWishlistFailure extends FetchWishlistState {
  final String error;
  FetchWishlistFailure({required this.error});
}