import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreImageService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> selectionSlot(String imageUrl, int index) async {
    try {
      final List<String> docIds = [];
      if (index == 1) {
        docIds.add('user_doc');
      } else if (index == 2) {
        docIds.add('barber_doc');
      } else if (index == 3) {
        docIds.addAll(['user_doc', 'barber_doc']);
      } else {
        return false;
      }
      for (String docId in docIds) {
        final success = await storeImageUrlInFirestore(imageUrl, docId);
        if (!success) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> storeImageUrlInFirestore(String imageUrl, String docId) async {
    try {
      final docRef = firestore.collection('banner_images').doc(docId);
      await docRef.set({
        'image_urls': FieldValue.arrayUnion([imageUrl]),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}



//! Delete Image from Firestore

class FirestoreImageServiceDeletion{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool>  deleteImageUrl({required String imageUrl,required int index,required int imageIndex}) async{
    try {
      final String docId = _getDocIdsForIndex(index);
     
      if(docId.isEmpty){
       return false;
      }
     
      final DocumentReference<Map<String, dynamic>> docRef = firestore.collection('banner_images').doc(docId);
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
       
       if (!docSnapshot.exists) {
         return false;
       }
      
      final List<dynamic>? imageUrls = docSnapshot.data()?['image_urls'];

      if (imageIndex < 0 || imageIndex >= imageUrls!.length) {
        return false;
      }

      return await _imageUrlDeletion(imageUrls: imageUrls, imageIndex: imageIndex, docref: docRef);
    } catch (e) {
      return false;
    }
  }
}

String _getDocIdsForIndex(int index){
  if(index == 1) {
    return 'user_doc';
  }else if(index == 2){
    return 'barber_doc';
  }else{
    return '';
  }
}


Future<bool> _imageUrlDeletion({required  imageUrls, required int imageIndex, required DocumentReference<Map<String, dynamic>> docref}) async{
  try {
    final String imageUrlToDelete = imageUrls[imageIndex];
    await docref.update({'image_urls': FieldValue.arrayRemove([imageUrlToDelete])});
    return true;
  } catch (e) {
    return false;
  }
}