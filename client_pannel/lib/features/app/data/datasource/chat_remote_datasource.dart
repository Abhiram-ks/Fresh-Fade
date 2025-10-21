import 'package:client_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../model/barber_model.dart';
import '../model/chat_model.dart';

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


  //! update chat status
  Future<void> updateChatStatus({required String userId, required String barberId}) async {
    try {
      final querySnapshot =  await firestore
      .collection('chat')
      .where('userId', isEqualTo: userId)
      .where('barberId', isEqualTo: barberId)
      .where('senderId', isEqualTo: barberId)
      .where('isSee', isEqualTo: false)
      .get();

      if (querySnapshot.docs.isEmpty) return;

      final batch = firestore.batch();
      querySnapshot.docs
          .where((doc) => doc['isSee'] == false)
          .map((doc) => batch.update(doc.reference, {'isSee': true}))
          .toList();

      await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //! send message
    Future<bool> sendMessage({required ChatModel message}) async {
    try {
      await firestore.collection('chat').add(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }


  

  // fetch last messag
  Stream<ChatModel?> latestMessage({
    required String userId,
    required String barberId,
  }) {
    try {
    return firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('softDelete', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return ChatModel.fromMap(doc.id, doc.data());
    });
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // fetch number of messages 
  Stream<int> messageBadges({
    required String userId,
    required String barberId,
  }) {
    try {
    return firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('senderId', isEqualTo: barberId)
        .where('isSee', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}