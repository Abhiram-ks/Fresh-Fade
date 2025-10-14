import 'package:barber_pannel/features/app/domain/entity/post_entity.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_posts_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'fetch_posts_event.dart';
part 'fetch_posts_state.dart';

class FetchPostsBloc extends Bloc<FetchPostsEvent, FetchPostsState> {
  final AuthLocalDatasource localDB;
  final GetPostsUseCase useCase;

  FetchPostsBloc({
    required this.localDB,
    required this.useCase,
  }) : super(FetchPostsInitial()) {
    on<FetchPostsRequest>((event, emit) async {
      emit(FetchPostsLoading());
      try {
        final String? barberId = await localDB.get();
        if (barberId == null) {
          emit(FetchPostsError(message: 'Barber ID not found'));
          return;
        }

        await emit.forEach<List<PostEntity>>(
          useCase(barberId: barberId),
          onData: (posts) {
            if (posts.isEmpty) {
              return FetchPostsEmpty();
            } else {
              return FetchPostsLoaded(posts: posts);
            }
          },
          onError: (error, stackTrace) => FetchPostsError(
            message: 'Failed to fetch posts: ${error.toString()}',
          ),
        );
      } catch (e) {
        emit(FetchPostsError(message: e.toString()));
      }
    });
  }
}
