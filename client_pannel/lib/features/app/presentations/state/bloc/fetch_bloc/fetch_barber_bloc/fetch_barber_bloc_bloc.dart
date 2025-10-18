import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/barber_entity.dart';
import '../../../../../domain/usecase/get_all_barbers_usecase.dart';

part 'fetch_barber_bloc_event.dart';
part 'fetch_barber_bloc_state.dart';


class FetchAllbarberBloc
    extends Bloc<FetchAllbarberEvent, FetchAllbarberListState> {
  final GetAllBarbersUseCase getAllBarbersUseCase;

  FetchAllbarberBloc({required this.getAllBarbersUseCase})
      : super(FetchAllbarberInitial()) {
    on<FetchAllBarbersRequested>(_onFetchAllBarbersRequested);
    on<SearchBarbersRequested>(_onSearchBarbersRequested);
    on<FilterBarbersRequested>(_onFilterBarbersRequested); 
  }

  Future<void> _onFetchAllBarbersRequested(
      FetchAllBarbersRequested event, Emitter<FetchAllbarberListState> emit) async {
    emit(FetchAllbarberLoading());

    await emit.forEach<List<BarberEntity>>(
        getAllBarbersUseCase(), onData: (barbers) {
      // final verifiedBarbers =  barbers.where((barber) => barber.isVerified).toList();
      log('isvarifiled ${barbers.length}');
      if (barbers.isEmpty) {
        return FetchAllbarberListEmpty();
      } else {
        return FetchAllbarberSuccess(barbers: barbers);
      }
    }, onError: (error, stackTrace) {
      return FetchAllbarberFailure(error.toString());
    });
  }

  /* Handles the searching logic for the barbers field within the BLoC */

  Future<void> _onSearchBarbersRequested(
      SearchBarbersRequested event, Emitter<FetchAllbarberListState> emit) async {

    emit(FetchAllbarberLoading());

    await emit.forEach<List<BarberEntity>>(
      getAllBarbersUseCase(),
      onData: (barbers) {
        final filteredBarbers = barbers
            .where((barber) => barber.ventureName
                    .toLowerCase().trim()
                    .contains(event.searchTerm.toLowerCase().trim()))
            .toList();

        
        if (filteredBarbers.isEmpty) {
          return FetchAllbarberListEmpty();
        } else {
          return FetchAllbarberSuccess(barbers: filteredBarbers);
        }
      },
      onError: (error, stackTrace) {
        return FetchAllbarberFailure(error.toString());
      },
    );
  }
 Future<void> _onFilterBarbersRequested(
  FilterBarbersRequested event,
  Emitter<FetchAllbarberListState> emit,
) async {
  emit(FetchAllbarberLoading());
  
  try {
    final List<BarberEntity> barbers = await getAllBarbersUseCase().first;
    List<BarberEntity> filteredList = [];
    
    for (final barber in barbers) {
      bool genderMatch = true;
      if (event.gender != null && event.gender!.isNotEmpty) {
        if (event.gender!.toLowerCase() == "unisex") {
          genderMatch = true;
        } else {
          genderMatch = barber.gender?.toLowerCase() == event.gender!.toLowerCase();
        }
      }
      

      final ratingMatch = event.rating <= 0.0 || barber.rating >= event.rating;
      
      if (!genderMatch || !ratingMatch) continue;

      if (event.selectServices.isNotEmpty) {
        try {
          final serviceDoc = await FirebaseFirestore.instance
              .collection('individual_barber_services')
              .doc(barber.uid)
              .get();
          
          if (!serviceDoc.exists) {
            continue;
          }
          
          final Map<String, dynamic> docData = serviceDoc.data() ?? {};
          Map<String, dynamic> servicesMap = {};
          
          if (docData.containsKey('services') && docData['services'] is Map) {
            servicesMap = docData['services'] as Map<String, dynamic>;
          } else {
            servicesMap = docData;
          }
          
          bool hasMatchingServices = false;
          
          for (String selectedService in event.selectServices) {
            if (servicesMap.keys.any((key) => 
                key.toLowerCase() == selectedService.toLowerCase())) {
              hasMatchingServices = true;
              break;
            }
          }
          
          if (hasMatchingServices) {
            filteredList.add(barber);
          }
        } catch (e) {
          continue;
        }
      } else {
        filteredList.add(barber);
      }
    }
    
    if (filteredList.isEmpty) {
      emit(FetchAllbarberListEmpty());
    } else {
      emit(FetchAllbarberSuccess(barbers: filteredList));
    }
  } catch (e) {
    emit(FetchAllbarberFailure(e.toString()));
  }
}
}
