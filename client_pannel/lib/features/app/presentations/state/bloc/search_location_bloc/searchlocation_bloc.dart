import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
part 'searchlocation_event.dart';
part 'searchlocation_state.dart';

class SerchlocatonBloc extends Bloc<SerchlocatonEvent, SerchlocatonState> {
  SerchlocatonBloc() : super(SerchlocatonInitial()) {
    on<SearchLocationEvent>((event, emit) async {
  try {
   final url = Uri.parse(
    'https://nominatim.openstreetmap.org/search?q=${event.query}&format=json&addressdetails=1');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      log(response.body);
      final List<dynamic> data = json.decode(response.body);
      emit(SearchLocationLoaded(data));
      if (data.isEmpty) {
        emit(SearchLocationError('Empty'));
      }
    } else {
      emit(SearchLocationError("Failed to fetch suggestions"));
    }
  } catch (e) {
    emit(SearchLocationError('Error: $e'));
  }
});

    on<SelectLocationEvent>((event, emit) {
      emit(LocationSelected(event.latitude, event.longitude, event.address));
    });
  }
}