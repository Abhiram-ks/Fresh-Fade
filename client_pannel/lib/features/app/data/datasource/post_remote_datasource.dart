
import 'package:client_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:client_pannel/features/app/data/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../model/barber_model.dart';
import '../model/post_with_barber_model.dart';

class PostRemoteDatasource {
  final BarberRemoteDatasource barber;
  final FirebaseFirestore firestore;

  PostRemoteDatasource({required this.barber, required this.firestore});

  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers() {
    return barber.streamAllBarbers().switchMap((barberList) {
      if (barberList.isEmpty) {
        return Stream.value([]);
      }

      final postWithBarberStreams = barberList
          .map(_mapBarberToPostStream)
          .cast<Stream<List<PostWithBarberModel>>>();

      return Rx.combineLatestList(postWithBarberStreams).map(
        (combined) => combined.expand((e) => e).toList(),
      );
    });
  }


  Stream<List<PostWithBarberModel>> _mapBarberToPostStream(BarberModel barber){
    final postsRef = firestore
        .collection('posts')
        .doc(barber.uid)
        .collection('Post')
        .orderBy('createdAt', descending: true);

    return postsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final post = PostModel.fromDocument(barber.uid, doc);
        return PostWithBarberModel(post: post, barber: barber);
      }).toList();
    });
  }


  //Fetch barber individual pos
  Stream<List<PostModel>> fetchBarberIndividualPosts(String barberId) {
    try {
      final postRef = firestore
      .collection('posts')
      .doc(barberId)
      .collection('Post')
      .orderBy('createdAt', descending: true);

      return postRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return PostModel.fromDocument(barberId, doc);
        }).toList();
      }).handleError((e) {
        throw Exception(e.toString());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  /// fetch all posts
  Stream<List<BarberModel>> streamChat({required String userId}) {
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
          .map((id) => barber.streamBarber(id)
              .handleError((e) {
                throw Exception(e.toString());
              }))
          .toList();

      return Rx.combineLatestList<BarberModel>(barberStreams);
    });
  }




}
