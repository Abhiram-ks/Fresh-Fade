import 'package:admin_pannel/features/data/model/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerRemoteDatasource {
  final FirebaseFirestore firestore;

  BannerRemoteDatasource(this.firestore);

  //! Fetch Client Banner
  Stream<BannerModel> getClientBannerStream() {
    try {
      return firestore
          .collection('banner_images')
          .doc('user_doc')
          .snapshots()
          .map((snapshot) {
        final data = snapshot.data() ?? {};
        return BannerModel.fromMap(data);
      });
    } catch (e) {
      throw Exception('Failed to fetch client banner: $e');
    }
  }

  //! Fetch Barber Banner
  Stream<BannerModel> getBarberBannerStream() {
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
      throw Exception('Failed to fetch barber banner: $e');
    }
  }
}
