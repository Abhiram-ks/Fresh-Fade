import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/repo/barbershop_repo_impl.dart';
import 'package:flutter/material.dart';
import '../../../../data/model/barbershop_entity.dart';

part 'nearby_barbers_event.dart';
part 'nearby_barbers_state.dart';


class NearbyBarbersBloc extends Bloc<NearbyBarbersEvent, NearbyBarbersState> {
  final GetNearbyBarberShops getNearbyBarberShops;

  NearbyBarbersBloc(this.getNearbyBarberShops) : super(NearbyBarbersInitial()) {
    on<LoadNearbyBarbers>((event, emit) async {
      emit(NearbyBarbersLoading());
      try {
        final barbers = await getNearbyBarberShops(event.lat, event.lng,event.around);
        emit(NearbyBarbersLoaded(barbers,event.around));
      } catch (e) {
        emit(NearbyBarbersError(e.toString()));
      }
    });
  }
}