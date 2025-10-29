import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/data/datasource/auth_local_datasource.dart';
import '../../../../domain/usecase/wishlist_service_usecase.dart';

part 'wish_list_fuction_state.dart';

class WishListFuctionCubit extends Cubit<WishListFuctionState> {
  final WishlistServiceUsecase wishlistServiceUsecase;
  final AuthLocalDatasource localDB;

  WishListFuctionCubit({
    required this.wishlistServiceUsecase,
    required this.localDB,
  }) : super(WishListFuctionInitial());

  Future<void> toggleWishlist({
    required bool isLiked,
    required String barberId,
  }) async {
    try {
      final String? userId = await localDB.get();
      if (userId == null || userId.isEmpty) {
        return;
      }
      if (isLiked) {
        await wishlistServiceUsecase.removeLike(userId: userId, barberId: barberId);
      } else {
        await wishlistServiceUsecase.addLike(userId: userId, barberId: barberId);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
