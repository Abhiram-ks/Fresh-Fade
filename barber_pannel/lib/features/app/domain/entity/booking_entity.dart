class BookingEntity {
  final String? bookingId;
  final String userId;
  final String barberId;
  final int duration;
  final String paymentMethod;
  final DateTime date;
  final Map<String, double> serviceType;
  final List<DateTime> slotTime;
  final double amount;
  final double platformFee;
  final String status;
  final String otp;
  final String transaction;
  final String slotDate;
  final List<String> slotId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingEntity({
    this.bookingId,
    required this.userId,
    required this.barberId,
    required this.duration,
    required this.paymentMethod,
    required this.createdAt,
    required this.serviceType,
    required this.slotTime,
    required this.amount,
    required this.status,
    required this.platformFee,
    required this.otp,
    required this.transaction,
    required this.slotId,
    required this.slotDate,
    required this.date,
    required this.updatedAt,
  });
}
