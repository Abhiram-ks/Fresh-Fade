import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../../auth/data/datasource/auth_local_datasource.dart';
import '../../../../../domain/entity/barber_entity.dart';
import '../../../../../domain/usecase/wishlist_service_usecase.dart';
part 'fetch_wishlist_event.dart';
part 'fetch_wishlist_state.dart';

class FetchWishlistBloc extends Bloc<FetchWishlistEvent, FetchWishlistState> {
  final WishlistServiceUsecase wishlistServiceUsecase;
  final AuthLocalDatasource localDB;

  FetchWishlistBloc({required this.wishlistServiceUsecase, required this.localDB}) : super(FetchWishlistInitial()) {
    on<FetchWishlistRequest>((event, emit) async {
      emit(FetchWishlistLoading());
      try {
        final String? userId = await localDB.get();
        if (userId == null || userId.isEmpty) {
          emit(FetchWishlistFailure(error: 'Token expired. Please login again.'));
          return;
        }

        await emit.forEach(
          wishlistServiceUsecase.streamWishList(userId: userId), 
          onData: (barber) {
            if (barber.isEmpty) {
              return FetchWishlistEmpty();
            } else {
              return FetchWishlistSuccess(wishlists: barber);
            }
          },
          onError: (error, stackTrace) => FetchWishlistFailure(error: error.toString()),
        );
      } catch (e) {
        emit(FetchWishlistFailure(error: e.toString()));
      }
    });
  }
}
