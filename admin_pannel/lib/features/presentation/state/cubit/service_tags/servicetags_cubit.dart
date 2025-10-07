import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
part 'servicetags_state.dart';

class ServiceTagsCubitCubit extends Cubit<ServiceTagsCubitState> {
  ServiceTagsCubitCubit() : super(ServiceTagsCubitInitial());
  void toggleActions(bool currentVisibility) {
    if (currentVisibility) {
      emit(ServiceTagsHideActions());
    } else {
      emit(ServiceTagsShowActions());
    }
  }
}