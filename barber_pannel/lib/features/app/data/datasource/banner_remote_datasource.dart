import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/banner_model.dart';

class BannerRemoteDatasource {
  final FirebaseFirestore firestore;

  BannerRemoteDatasource({required this.firestore});

  Stream<BannerModel> banner() {
    try {
      return firestore
          .collection('banner_images')
          .doc('barber_doc')
          .snapshots()
          .map((snapshot) {
            final data = snapshot.data() ?? {};
            return BannerModel.fromMap(data);
          });
    } catch (e) {
      throw Exception(e);
    }
  }
}
