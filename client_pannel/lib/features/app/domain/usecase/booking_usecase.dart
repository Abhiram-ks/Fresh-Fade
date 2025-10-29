import '../../data/model/booking_model.dart';
import '../../data/model/booking_with_barber_model.dart';
import '../entity/booking_entity.dart';
import '../repo/booking_repo.dart';

class BookingUsecase {
  final BookingRepo bookingRepo;

  BookingUsecase({required this.bookingRepo});

  Future<bool> createBooking(BookingModel booking) async {
    return await bookingRepo.createBooking(booking);
  }


  //Fetch bookings with barber
  Stream<List<BookingWithBarberModel>> getAllBooking({required String userId}) {
    return bookingRepo.getAllBooking(userId: userId);
  }

  //Fetch bookings with barber filter
  Stream<List<BookingWithBarberModel>> getAllBookingFilter({required String userId, required String filter}) {
    return bookingRepo.getAllBookingFilter(userId: userId, filter: filter);
  }


  // Fetch specific document
  // Get to return BookingEntity
  Stream<BookingEntity> getBookingById({required String bookingId}) {
    return bookingRepo.getBookingById(bookingId: bookingId);
  }
}