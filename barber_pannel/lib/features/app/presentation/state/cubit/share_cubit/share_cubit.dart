import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../service/share/share_service.dart';
part 'share_state.dart';

class ShareCubit extends Cubit<ShareState> {
  final ShareService shareService;
  ShareCubit({required this.shareService}) : super(ShareInitial());

  Future<void> sharePost({required String text, required String ventureName, required String location, required String? imageUrl}) async {
    emit(ShareLoading());
    try {
      final result = await shareService.sharePost(text: text, ventureName: ventureName, location: location, imageUrl: imageUrl);
      if (result) {
        emit(ShareSuccess(text: text, ventureName: ventureName, location: location, imageUrl: imageUrl));
      } else {
        emit(ShareFailure(error: 'Failed do share post to Share dismissed.'));
      }
    } catch (e) {
      emit(ShareFailure(error: e.toString()));
    }
  }
}
