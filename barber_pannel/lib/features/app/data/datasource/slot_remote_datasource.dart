import 'package:barber_pannel/features/app/data/model/date_model.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/duration_picker/duration_picker_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/usecase/generate_slot_usecase.dart';
import '../model/slot_model.dart';

abstract class FetchSlotsRepository {
  Stream<List<DateModel>> streamDates(String barberUid);
  Stream<List<SlotModel>> streamSlots({required String barberUid,required DateTime selectedDate});
  
}

class FetchSlotsRepositoryImpl implements FetchSlotsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  
  @override
  Stream<List<DateModel>> streamDates(String barberUid) {
    final datesCollection = _firestore
        .collection('slots')
        .doc(barberUid)
        .collection('dates');

    return datesCollection.snapshots().map((datesSnapshot) {
      try {
        return datesSnapshot.docs.map((doc) {
          return DateModel.fromDocument(doc);
        }).toList();
      } catch (e) {
        return <DateModel>[];  
      }
    });
  }

  @override
  Stream<List<SlotModel>> streamSlots({required String barberUid, required DateTime selectedDate }) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    final datesCollection = _firestore
        .collection('slots')
        .doc(barberUid)
        .collection('dates')
        .doc(formattedDate)
        .collection('slot')
        .orderBy('startTime');

    return datesCollection.snapshots().map((slotSnapshot) {
      try {

        final List<SlotModel> allSlots = slotSnapshot.docs.map((doc) => SlotModel.fromMap(doc.data())).toList();

        allSlots.sort((a,b) => a.startTime.compareTo(b.startTime));
        return allSlots;
      } catch (e) {
        return <SlotModel>[];
      }
    });
  }
}


//! slot remote datasource
//slot upload remote datasource


abstract class SlotRepository  {
  Future<bool> uploadSlots({required String barberUid,required DurationTime duration ,required DateTime selectedDate,required List<Map<String, dynamic>> slotTime});
}

class SlotRepositoryImpl implements SlotRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Future<bool> uploadSlots({
    required String barberUid,
    required DateTime selectedDate,
    required List<Map<String, dynamic>> slotTime,
    required DurationTime duration,
  }) async {
    try {
      String formattedDateForDoc = DateFormat('dd-MM-yyyy').format(selectedDate);
      String formattedDateForField = DateFormat('dd/MM/yyyy').format(selectedDate);
      IntravelConverter converter = IntravelConverter(duration);
      Duration slotDuration = converter.getDurationType();

     final dateDocRef = _firestore
          .collection('slots')
          .doc(barberUid)
          .collection('dates')
          .doc(formattedDateForDoc);

      return await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(dateDocRef);

      if (docSnapshot.exists) {
        return false;
      }

        transaction.set(dateDocRef, {'createdAt': FieldValue.serverTimestamp()});

      for (Map<String, dynamic> slot in slotTime) {
        
        final DateTime startDateTime = slot['startDateTime'];
        final DateTime endDateTime = slot['endDateTime'];

        final slotRef = dateDocRef.collection('slot').doc();

        final slotModel = SlotModel(
          docId: dateDocRef.id,
          subDocId: slotRef.id,
          shopId: barberUid,
          startTime: startDateTime,
          endTime: endDateTime,
          date: formattedDateForField,
          booked: false,
          available: true,
          duration: slotDuration,
        );
        
        transaction.set(slotRef, slotModel.toMap());
      }

      return true;
    });
  } catch (e) {
    return false;
  }
}
}