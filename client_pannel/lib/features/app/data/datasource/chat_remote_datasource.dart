import 'package:client_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../model/barber_model.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore firestore;
  final BarberRemoteDatasource barberRemoteDatasource;
  ChatRemoteDatasource({required this.firestore, required this.barberRemoteDatasource});

  Stream<List<BarberModel>> streamChats({required String userId}) {
   try {
         return firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .switchMap((querySnapshot) {
      final barberIds = querySnapshot.docs
          .map((doc) => doc.data()['barberId'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      if (barberIds.isEmpty) {
        return Stream.value(<BarberModel>[]);
      }


      final barberStreams = barberIds
          .map((id) => barberRemoteDatasource.streamBarber(id)
              .handleError((e) {
                throw Exception(e.toString());
              }))
          .toList();

      return Rx.combineLatestList<BarberModel>(barberStreams);
    });
   } catch (e) {
    throw Exception(e.toString());  
   }
  }
}