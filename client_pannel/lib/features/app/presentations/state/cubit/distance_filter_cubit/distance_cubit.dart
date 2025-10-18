import 'package:bloc/bloc.dart';
import 'distance_state.dart';


class DistanceFilterCubit extends Cubit<DistanceFilter> {
  DistanceFilterCubit() : super(DistanceFilter.km5);

  void selectDistance(DistanceFilter distance) => emit(distance);
}

class SearchInputCubit extends Cubit<bool> {
  SearchInputCubit() : super(true); 

  void update(String text) => emit(text.isEmpty);
}
