import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.photoUrl,
    super.phone,
    super.address,
    super.age,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
    return UserModel(
      id: uid,
      name: json['name'] ?? 'Unknown Name',
      email: json['email'] ?? 'Unknown Email',
      photoUrl: json['photoUrl'] ?? '',
      phone: json['phone'],
      address: json['address'],
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
      'age': age,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}