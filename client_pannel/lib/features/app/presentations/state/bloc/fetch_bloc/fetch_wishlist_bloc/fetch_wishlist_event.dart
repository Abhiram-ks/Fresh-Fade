part of 'fetch_wishlist_bloc.dart';

@immutable
abstract class FetchWishlistEvent {}

final class FetchWishlistRequest extends FetchWishlistEvent {}