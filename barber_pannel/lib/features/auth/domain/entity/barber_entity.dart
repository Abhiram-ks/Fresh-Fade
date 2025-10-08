class BarberEntity {
  final String uid;
  final String barberName;
  final String ventureName;
  final String phoneNumber;
  final String address;
  final String email;
  final bool isVerified;
  final bool isBloc;
  final String? image;
  final int? age;
  final String? detailImage;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BarberEntity({
    required this.uid,
    required this.barberName,
    required this.ventureName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isVerified,
    required this.isBloc,
    this.image,
    this.age,
    this.detailImage,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });
}