import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../app/domain/usecase/delete_post_usecase.dart';

part 'delete_post_state.dart';

class DeletePostCubit extends Cubit<DeletePostState> {
  final DeletePostUsecase deletePostUsecase;
  DeletePostCubit({required this.deletePostUsecase}) : super(DeletePostInitial());

  void deletePost({required String barberId, required String docId}) async {
    emit(DeletePostLoading());
    try {
      final result = await deletePostUsecase.call(barberId: barberId, docId: docId);
      if (result) {
        emit(DeletePostSuccess());
      } else {
        emit(DeletePostErorr(error: 'Failed to delete post'));
      }
    } catch (e) {
      emit(DeletePostErorr(error: e.toString()));
    }
  }
}
