import '../../entities/booking.dart';
import '../../repositories/booking_repository_interface.dart';

/// Rezervasyonun durumunu (onay, ret, tamamlama) yöneten ve güncelleyen kullanım senaryosu.
class ManageBookingStatusUseCase {
  final BookingRepositoryInterface repository;

  const ManageBookingStatusUseCase(this.repository);

  Future<void> updateStatus(String bookingId, BookingStatus newStatus) {
    return repository.updateBookingStatus(bookingId, newStatus);
  }

  Future<void> cancelBooking(String bookingId) {
    return repository.deleteBooking(bookingId);
  }
}
