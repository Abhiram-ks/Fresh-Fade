
import 'package:client_pannel/features/app/data/model/data_model.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SlotRemoteDatasource {
  final FirebaseFirestore firestore;

  SlotRemoteDatasource({required this.firestore});

  Stream<List<DateModel>> streamSlots({required String barberId}) {
    final dataCollection = firestore
        .collection('slots')
        .doc(barberId)
        .collection('dates');

    return dataCollection.snapshots().map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          return DateModel.fromDocument(doc);
        }).toList();
      } catch (e) {
        return <DateModel>[];
      }
    });
  }

  Stream<List<SlotModel>> streamSlotsForDate({
    required String barberId,
    required DateTime time,
  }) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(time);

    final dataCollection = firestore
        .collection('slots')
        .doc(barberId)
        .collection('dates')
        .doc(formattedDate)
        .collection('slot')
        .orderBy('startTime');

    return dataCollection.snapshots().map((slotSnapshot) {
      try {
        final List<SlotModel> allSlots =
            slotSnapshot.docs
                .map((doc) => SlotModel.fromMap(doc.data()))
                .toList();

        allSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
        return allSlots;
      } catch (e) {
        throw Exception(e.toString());
      }
    });
  }

  // check slots availability for cod payment
  Future<bool> slotCheking({
    required String barberId,
    required List<SlotModel> selectedSlots,
  }) async {
    try {
      for (final slot in selectedSlots) {
        final docRef = firestore
            .collection('slots')
            .doc(barberId)
            .collection('dates')
            .doc(slot.docId)
            .collection('slot')
            .doc(slot.subDocId);

        final snapshot = await docRef.get();

        if (!snapshot.exists) return false;

        final data = snapshot.data()!;
        final bool isAvailable = data['available'] == true;
        final bool isNotBooked = data['booked'] == false;

        if (!isAvailable || !isNotBooked) return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Updates COD booked slots
  // returns true if all slots are booked successfully, otherwise false
  // throws an exception if any error occurs
  Future<bool> slotBooking({
    required String barberID,
    required List<SlotModel> selectedSlots,
  }) async {
    final WriteBatch batch = firestore.batch();
    try {
      for (final slot in selectedSlots) {
        final docRef = firestore
            .collection('slots')
            .doc(barberID)
            .collection('dates')
            .doc(slot.docId)
            .collection('slot')
            .doc(slot.subDocId);

        final snapshot = await docRef.get();
        if (!snapshot.exists) return false;

        final data = snapshot.data()!;
        final bool isAvailable = data['available'] == true;
        final bool isNotBooked = data['booked'] == false;

        
        if (!isAvailable || !isNotBooked) return false;

        batch.update(docRef, {'available': false, 'booked': true});
      }
      try {
        await batch.commit();
        return true;

      } catch (e) {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // cancel slots
  // updates slots to available and booked false... Mark the slots as available and booked false

  Future<bool> slotCancelStatus({
    required String barberId,
    required String docId,
    required List<String> slotId,
  }) async {
    try {
      DocumentReference dateDocRef = firestore
      .collection('slots')
      .doc(barberId)
      .collection('dates')
      .doc(docId);

      DocumentSnapshot slotDocSnapshot = await dateDocRef.get();
      if (!slotDocSnapshot.exists) return false;

      WriteBatch batch = firestore.batch();

      for (String slotDocId in slotId) {
        DocumentReference slotRef = dateDocRef.collection('slot').doc(slotDocId);

        batch.update(slotRef,{
          'booked': false,
          'available': true,
        });
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
