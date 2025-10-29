import 'package:client_pannel/features/app/data/model/data_model.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import '../repo/slot_repo.dart';

class GetSlotsDatasUsecase {
  final SlotRepository repository;

  GetSlotsDatasUsecase({required this.repository});
  
  // get dates for a individual barber
  // throws an exception if any error occurs
  // returns a stream of dates for a barber
  Stream<List<DateModel>> call({required String barberId}) {
    return repository.streamDates(barberId: barberId);
  }


  // get slots for a specific date for a barber
  // throws an exception if any error occurs
  // returns a stream of slots for a specific date for a barber
  Stream<List<SlotModel>> execute({required String barberId, required DateTime time}) {
    return repository.streamSlotsForDate(barberId: barberId, time: time);
  }

  // check slots availability for cod payment
  // throws an exception if any error occurs
  // returns true if all slots are available, otherwise false
  Future<bool> checkSlotsAvailability({required String barberId, required List<SlotModel> selectedSlots}) async {
    return repository.slotChecking(barberId: barberId, selectedSlots: selectedSlots);
  }

  // Updates COD booked slots
  // throws an exception if any error occurs
  // returns true if all slots are booked successfully, otherwise false
  Future<bool> updateSlotsBooking({required String barberID, required List<SlotModel> selectedSlots}) async {
    return repository.slotUpdatesBooking(barberID: barberID, selectedSlots: selectedSlots);
  }

  // cancel slots
  // updates slots to available and booked false... Mark the slots as available and booked false
  // returns true if slots are cancelled successfully, otherwise false
  // throws an exception if any error occurs
  Future<bool> cancelSlots({required String barberId, required String docId, required List<String> slotId}) async {
    return repository.slotCancelStatus(barberId: barberId, docId: docId, slotId: slotId);
  } 
}