import 'package:client_pannel/features/app/data/datasource/slot_remote_datasource.dart';
import 'package:client_pannel/features/app/data/model/data_model.dart';
import 'package:client_pannel/features/app/domain/repo/slot_repo.dart';

import '../model/slot_model.dart';

class SlotRepositoryImpl implements SlotRepository {
  final SlotRemoteDatasource remoteDatasource;

  SlotRepositoryImpl({required this.remoteDatasource});

  // returns a stream of dates for a barber
  // throws an exception if any error occurs
  @override
  Stream<List<DateModel>> streamDates({required String barberId}) {
     try {
       return remoteDatasource.streamSlots(barberId: barberId);
     } catch (e) {
       rethrow;
     }
  }


  // returns a stream of slots for a specific date for a barber
  // throws an exception if any error occurs
  @override
  Stream<List<SlotModel>> streamSlotsForDate({required String barberId, required DateTime time}) {
    try {
      return remoteDatasource.streamSlotsForDate(barberId: barberId, time: time);
    } catch (e) {
      rethrow;
    }
  }

  // check slots availability for cod payment
  // returns true if all slots are available, otherwise false
  // throws an exception if any error occurs
  @override
  Future<bool> slotChecking({required String barberId, required List<SlotModel> selectedSlots}) async {
    try {
      return await remoteDatasource.slotCheking(barberId: barberId, selectedSlots: selectedSlots);
    } catch (e) {
      rethrow;
    }
  }
  
  // Updates COD booked slots
  // returns true if all slots are booked successfully, otherwise false
  // throws an exception if any error occurs
  @override
  Future<bool> slotUpdatesBooking({required String barberID, required List<SlotModel> selectedSlots}) async {
    try {
      return await remoteDatasource.slotBooking(barberID: barberID, selectedSlots: selectedSlots);
    } catch (e) {
      rethrow;
    }
  }

  // cancel slots
  // updates slots to available and booked false... Mark the slots as available and booked false
  // returns true if slots are cancelled successfully, otherwise false
  // throws an exception if any error occurs
  @override
  Future<bool> slotCancelStatus({required String barberId, required String docId, required List<String> slotId}) async {
    try {
      return await remoteDatasource.slotCancelStatus(barberId: barberId, docId: docId, slotId: slotId);
    } catch (e) {
      rethrow;
    }
  }
}