import 'package:client_pannel/features/app/data/model/data_model.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';

abstract class SlotRepository {
  // returns a stream of dates for a barber
  // throws an exception if any error occurs
  Stream<List<DateModel>> streamDates({required String barberId});

  // returns a stream of slots for a specific date for a barber
  // throws an exception if any error occurs
  Stream<List<SlotModel>> streamSlotsForDate({required String barberId, required DateTime time});
  
  // returns true if all slots are available, otherwise false
  // throws an exception if any error occurs
  // check slots availability for cod payment
  Future<bool> slotChecking({required String barberId, required List<SlotModel> selectedSlots});

  // Updates COD booked slots
  // returns true if all slots are booked successfully, otherwise false
  // throws an exception if any error occurs
  Future<bool> slotUpdatesBooking({required String barberID, required List<SlotModel> selectedSlots});

  // cancel slots
  // updates slots to available and booked false... Mark the slots as available and booked false
  // returns true if slots are cancelled successfully, otherwise false
  // throws an exception if any error occurs
  Future<bool> slotCancelStatus({required String barberId, required String docId, required List<String> slotId});
}