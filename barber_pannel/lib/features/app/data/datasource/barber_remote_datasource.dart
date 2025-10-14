import 'package:barber_pannel/features/auth/data/model/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberRemoteDatasource {
  final FirebaseFirestore firestore;

  BarberRemoteDatasource({required this.firestore});

  Stream<BarberModel> streamBarber(String barberId) {
   try {
    return firestore
    .collection('barbers')
    .doc(barberId)
    .snapshots()
    .map((event) => BarberModel.fromMap(
      event.data() ?? {}, event.id));
   } catch (e) {
    throw Exception(e);
   }
  }
  

  /// Update barber profile
  /// 
  /// Only updates fields that are provided (non-null)
  /// @param uid: The barber's unique ID
  /// @param barberName: Optional - The barber's name
  /// @param ventureName: Optional - The venture/shop name
  /// @param phoneNumber: Optional - Phone number
  /// @param address: Optional - Business address
  /// @param image: Optional - Profile image URL
  /// @param age: Optional - Age of the barber
  /// @return: True if update is successful
  /// @throws: Exception if barber not found or update fails
  Future<bool> updateBarber({
    required String uid,
    String? barberName,
    String? ventureName,
    String? phoneNumber,
    String? address,
    String? image,
    int? age,
  }) async {
    try {
      // Validate UID
      if (uid.isEmpty) {
        throw Exception('Barber ID cannot be empty');
      }

      final userDocRef = firestore.collection('barbers').doc(uid);
      final docSnapshot = await userDocRef.get();

      // Check if barber exists
      if (!docSnapshot.exists) {
        throw Exception('Barber profile not found');
      }

      // Build update map with only non-null values
      final Map<String, dynamic> updateData = {};

      if (barberName != null && barberName.isNotEmpty) {
        updateData['barberName'] = barberName;
      }
      if (ventureName != null && ventureName.isNotEmpty) {
        updateData['ventureName'] = ventureName;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        updateData['phoneNumber'] = phoneNumber;
      }
      if (address != null && address.isNotEmpty) {
        updateData['address'] = address;
      }
      if (image != null && image.isNotEmpty) {
        updateData['image'] = image;
      }
      if (age != null && age > 0) {
        updateData['age'] = age;
      }

      // Always update the timestamp
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      // Check if there's anything to update
      if (updateData.length == 1) {
        // Only timestamp, no actual data to update
        throw Exception('No valid data provided for update');
      }

      // Perform the update
      await userDocRef.update(updateData);
      return true;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message ?? e.code}');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> uploadNewField({
    required String uid,
    required String imageUrl,
    required String gender,
  }) async {
    try {
      firestore.
      collection('barbers')
      .doc(uid)
      .update({
        'DetailImage': imageUrl,
        'gender': gender,
      });
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
  
}