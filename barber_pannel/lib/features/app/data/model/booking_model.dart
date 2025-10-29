import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingModel extends BookingEntity {
  const BookingModel({
    super.bookingId,
    required super.userId,
    required super.barberId,
    required super.duration,
    required super.paymentMethod,
    required super.createdAt,
    required super.updatedAt,
    required super.serviceType,
    required super.slotTime,
    required super.amount,
    required super.platformFee,
    required super.status,
    required super.otp,
    required super.transaction,
    required super.slotId,
    required super.slotDate,
    required super.date,
  });

  factory BookingModel.fromMap(String bookingId, Map<String, dynamic> map) {
    return BookingModel(
      bookingId: bookingId,
      userId: map['userId'] as String? ?? '',
      barberId: map['barberId'] as String? ?? '',
      duration: map['duration'] is int
              ? map['duration']
              : int.tryParse(map['duration'].toString()) ?? 0,
      paymentMethod: map['paymentMethod'] as String? ?? '',
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceType: (map['serviceType'] as Map?)?.map(
            (key, value) => MapEntry(
              key.toString(),
              (value is num) ? value.toDouble() : 0.0,
            ),
          ) ??
          {},
      slotTime: (map['slotTime'] as List<dynamic>?)
              ?.map((ts) => (ts is Timestamp) ? ts.toDate() : DateTime.now())
              .toList() ??
          [],
      slotId: (map['slot_id'] as List<dynamic>?)
              ?.map((id) => id.toString())
              .toList() ??
          [],
      slotDate: map['slotDate'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (map['platformFee'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'pending',
      otp: map['otp'] as String? ?? '',
      transaction: map['transaction'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'barberId': barberId,
      'duration': duration,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'date': Timestamp.fromDate(date),
      'serviceType': serviceType,
      'slotTime': slotTime.map((dt) => Timestamp.fromDate(dt)).toList(),
      'slot_id': slotId,
      'slotDate': slotDate,
      'amount': amount,
      'platformFee': platformFee,
      'status': status,
      'otp': otp,
      'transaction': transaction,
    };
  }

  /// Convert Model to Entity
  BookingEntity toEntity() => BookingEntity(
    bookingId: bookingId,
    userId: userId,
    barberId: barberId,
    duration: duration,
    paymentMethod: paymentMethod,
    createdAt: createdAt,
    updatedAt: updatedAt,
    serviceType: serviceType,
    slotTime: slotTime,
    amount: amount,
    platformFee: platformFee,
    status: status,
    otp: otp,
    transaction: transaction,
    slotId: slotId,
    slotDate: slotDate,
    date: date,
  );

  /// Create Model from Entity (useful for saving to DB)
  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      bookingId: entity.bookingId,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
      barberId: entity.barberId,
      duration: entity.duration,
      paymentMethod: entity.paymentMethod,
      createdAt: entity.createdAt,
      serviceType: entity.serviceType,
      slotTime: entity.slotTime,
      amount: entity.amount,
      platformFee: entity.platformFee,
      status: entity.status,
      otp: entity.otp,
      transaction: entity.transaction,
      slotId: entity.slotId,
      slotDate: entity.slotDate,
      date: entity.date,
    );
  }
}