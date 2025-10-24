import 'dart:developer';

import 'package:barber_pannel/features/app/data/model/comment_model.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/usecase/get_comments_usecase.dart';

part 'fetch_comment_event.dart';
part 'fetch_comment_state.dart';

class FetchCommentBloc extends Bloc<FetchCommentEvent, FetchCommentState> {
  final GetCommentsUsecase getCommentsUsecase;
  final AuthLocalDatasource localDB;
  FetchCommentBloc({required this.getCommentsUsecase, required this.localDB}) : super(FetchCommentInitial()) {
    on<FetchCommentRequest>((event, emit) async {
      emit(FetchCommentLoading());

      try {
        final String? barberID = await localDB.get();

        if (barberID == null || barberID.isEmpty) {
          log('Barber ID is null or empty');
          emit(FetchCommentEmpty());
          return;
        }

        log('Fetching comments for post: ${event.docId}, barberID: $barberID');

        await emit.forEach(
          getCommentsUsecase.call(postDocId: event.docId, barberID: barberID),
           onData: (comments) {
            log('Received ${comments.length} comments from stream');
            if (comments.isEmpty) {
              log('Comments list is empty');
              return FetchCommentEmpty();
            } else {
              log('Successfully loaded ${comments.length} comments');
              return FetchCommentsSuccess(comments: comments, barberID: barberID);
            }
          },
          onError: (error, stackTrace) {
            log('Stream error in FetchCommentBloc: $error');
            log('Stack trace: $stackTrace');
            return FetchCommentsError(error: 'Failed to load comments: $error');
          },
          );
      } catch (e, stackTrace) {
        log('Exception in FetchCommentBloc: $e');
        log('Stack trace: $stackTrace');
        emit(FetchCommentsError(error: 'Failed to initialize comment loading: $e'));
      }
    });
  }
}
