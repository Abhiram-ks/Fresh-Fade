import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecase/wishlist_service_usecase.dart';
import '../../../../../auth/data/datasource/auth_local_datasource.dart';
part 'fetch_single_wishlist_state.dart';

class FetchSingleWishlistCubit extends Cubit<FetchSingleWishlistState> {
  final WishlistServiceUsecase wishlistServiceUsecase;
  final AuthLocalDatasource localDB;
  FetchSingleWishlistCubit({required this.wishlistServiceUsecase, required this.localDB}) : super(FetchSingleWishlistInitial());

  void fetchSingleWishlist({required String barberId}) async {
    try {
      final String? userId = await localDB.get();
      if (userId == null || userId.isEmpty) {
        return;
      }
      wishlistServiceUsecase.fetchSingleWishlist(userId: userId, barberId: barberId).listen((isLiked) {
        emit(FetchWishlistSinglebarberLoaded(isLiked));
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
