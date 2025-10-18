import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel extends BarberEntity {
  BarberModel({
    required super.uid,
    required super.barberName,
    required super.ventureName,
    required super.phoneNumber,
    required super.address,
    required super.email,
    required super.isVerified,
    required super.isBloc,
    required super.rating,
    super.image,
    super.age,
    super.detailImage,
    super.gender,
    super.createdAt,
    super.updatedAt,
  });

  //! Convert Model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'Uid': uid,
      'barberName': barberName,
      'ventureName': ventureName,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'isVerified': isVerified,
      'isBloc': isBloc,
      'rating': rating,
      'image': image ?? '',
      'age': age ?? 0,
      'DetailImage': detailImage ?? '',
      'gender': gender ?? '',
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  //! Convert Map from Firestore to Model
  factory BarberModel.fromMap(Map<String, dynamic> map, String uid, double rating) {
    return BarberModel(
      uid: uid,
      rating: map['rating'] ?? 0.0,
      barberName: map['barberName'] ?? '',
      ventureName: map['ventureName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      isVerified: map['isVerified'] ?? false,
      isBloc: map['isBloc'] ?? false,
      image: map['image'],
      age: map['age'],
      detailImage: map['DetailImage'] ?? '',
      gender: map['gender'] ?? '',
      
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  //! Convert Entity to Model
  factory BarberModel.fromEntity(BarberEntity entity) {
    return BarberModel(
      uid: entity.uid,
      barberName: entity.barberName,
      ventureName: entity.ventureName,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      email: entity.email,
      isVerified: entity.isVerified,
      isBloc: entity.isBloc,
      rating: entity.rating,
      image: entity.image,
      age: entity.age,
      detailImage: entity.detailImage,
      gender: entity.gender,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  //! Convert Model to Entity
  BarberEntity toEntity() {
    return BarberEntity(
      uid: uid,
      barberName: barberName,
      ventureName: ventureName,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      isVerified: isVerified,
      isBloc: isBloc,
      rating: rating,
      image: image,
      age: age,
      detailImage: detailImage,
      gender: gender,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}