import 'package:barber_pannel/features/app/data/datasource/user_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../model/chat_model.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore firestore;
  final UserRemoteDatasource userRemoteDatasource;
  ChatRemoteDatasource({
    required this.firestore,
    required this.userRemoteDatasource,
  });

  Stream<List<UserModel>> getChatUsers({required String barberId}) {
    try {
      return firestore
          .collection('chat')
          .where('barberId', isEqualTo: barberId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .switchMap((querySnapshot) {
            final userIds =
                querySnapshot.docs
                    .map((doc) => doc.data()['userId'] as String?)
                    .whereType<String>()
                    .toSet()
                    .toList();

            if (userIds.isEmpty) {
              return Stream.value(<UserModel>[]);
            }

            final userStreams =
                userIds
                    .map(
                      (id) => userRemoteDatasource
                          .streamUserData(userId: id)
                          .handleError((e) {}),
                    )
                    .toList();

            return Rx.combineLatestList<UserModel?>(
              userStreams,
            ).map((barbers) => barbers.whereType<UserModel>().toList());
          });
    } catch (e) {
      throw Exception(e);
    }
  }

  //Last message data
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
      throw Exception(e);
    }
  }


  //Message badges
  Stream<int> messageBadges({
    required String userId,
    required String barberId,
  }) {
    try {
    return firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('senderId', isEqualTo: userId)
        .where('isSee', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      throw Exception(e);
    }
  }
  


  //update status for chats
    Future<void> chatStatusChange({
    required String userId,
    required String barberId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('chat')
          .where('userId', isEqualTo: userId)
          .where('barberId', isEqualTo: barberId)
          .where('senderId', isEqualTo: userId)
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
      rethrow;
    }
  }


  ///! send to chat 
  ///
   Future<bool> sendMessage({required ChatModel message}) async {
    try {
      await firestore.collection('chat').add(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
