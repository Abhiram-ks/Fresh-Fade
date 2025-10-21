import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/post_entity.dart';
import '../../../../../domain/usecase/get_barber_individual_posts.dart';
part 'fetch_barber_post_event.dart';
part 'fetch_barber_post_state.dart';

class FetchBarberPostBloc extends Bloc<FetchBarberPostEvent, FetchBarberPostState> {
  final GetBarberIndividualPostsUseCase getBarberIndividualPostsUseCase;
  FetchBarberPostBloc({required this.getBarberIndividualPostsUseCase}) : super(FetchBarberPostInitial()) {
    on<FetchBarberPostRequest>((event, emit) async {
      emit(FetchBarberPostLoading());
      try {
        await emit.forEach(
          getBarberIndividualPostsUseCase.call(event.barberId),
          onData: (posts) {
            if (posts.isEmpty) {
              return FetchBarberPostEmpty();
            } else {
              return FetchBarberPostSuccess(posts: posts);
            }
          },
          onError: (error, __) => FetchBarberPostFailure(error: error.toString()),
        );
      } catch (e) {
        emit(FetchBarberPostFailure(error: e.toString()));
      }
    });
  }
}
