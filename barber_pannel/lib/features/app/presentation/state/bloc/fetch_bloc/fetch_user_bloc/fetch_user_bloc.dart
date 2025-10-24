import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/user_entity.dart';
import '../../../../../domain/repo/user_repo.dart';

part 'fetch_user_event.dart';
part 'fetch_user_state.dart';

class FetchUserBloc extends Bloc<FetchUserEvent, FetchUserState> {
  final UserRepository userRepository;
  final AuthLocalDatasource localDB;
  FetchUserBloc({required this.userRepository, required this.localDB}) : super(FetchUserInitial()) {
    on<FetchUserRequest>((event, emit) async {
      emit(FetchUserLoading());
      try {
        final String? barberId = await localDB.get();
        if(barberId == null || barberId.isEmpty) {
          emit(FetchUserError(message: 'Token Expired. Please login again.'));
          return;
        }
       await emit.forEach(
        userRepository.getUser(userId: event.userId), 
        onData: (data) {
          if(data != null) {
            return FetchUserLoaded(user: data, barberId: barberId);
          } else {
            return FetchUserError(message: 'Barber not found');
          }
        });
      } catch (e) {
        emit(FetchUserError(message: e.toString()));
      }
    });
  }
}
