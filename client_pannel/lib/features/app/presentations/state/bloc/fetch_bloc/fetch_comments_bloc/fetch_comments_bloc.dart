import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../../auth/data/datasource/auth_local_datasource.dart';
import '../../../../../domain/entity/comment_entity.dart';
import '../../../../../domain/usecase/get_comments_usecase.dart';

part 'fetch_comments_event.dart';
part 'fetch_comments_state.dart';

class FetchCommentsBloc extends Bloc<FetchCommentsEvent, FetchCommentsState> {
  final GetCommentsUseCase getCommentsUseCase;
  final AuthLocalDatasource localDB;
  
  FetchCommentsBloc({
    required this.getCommentsUseCase,
    required this.localDB,
  }) : super(FetchCommentsInitial()) {
    on<FetchCommentRequst>(_onFetchCommentsRequst);
  }

  Future<void> _onFetchCommentsRequst(
    FetchCommentRequst event,
    Emitter<FetchCommentsState> emit,
  ) async {
    emit(FetchCommentsLoading());

    try { 
      final String? userId = await localDB.get(); 
      if (userId == null || userId.isEmpty) {
        emit(FetchCommentsFailure(error: 'Token expired. Please login again.'));
        return;
      }
      
      await emit.forEach<List<CommentEntity>>(
        getCommentsUseCase(
          barberId: event.barberId,
          docId: event.docId,
        ), 
        onData: (comments) {
          if (comments.isEmpty) {
            return FetchCommentsEmpty();
          } else {
            return FetchCommentsLoaded(comments: comments, userId: userId);
          }
        },
        onError: (e, __) => FetchCommentsFailure(error: e.toString())
      );
    } catch (e) {
      emit(FetchCommentsFailure(error: e.toString()));
    }
  }
}
