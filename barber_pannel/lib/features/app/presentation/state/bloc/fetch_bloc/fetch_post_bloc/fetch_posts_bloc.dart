import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_posts_event.dart';
part 'fetch_posts_state.dart';

class FetchPostsBloc extends Bloc<FetchPostsEvent, FetchPostsState> {
  FetchPostsBloc() : super(FetchPostsInitial()) {
    on<FetchPostsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
