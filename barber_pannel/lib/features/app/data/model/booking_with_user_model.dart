import 'booking_model.dart';
import 'user_model.dart';

class BookingWithUserModel {
  final BookingModel booking;
  final UserModel user;

  BookingWithUserModel ({
    required this.booking,
    required this.user,
  });
}