import '../../entities/booking.dart';
import '../../repositories/booking_repository_interface.dart';

/// Yeni rezervasyon talebi oluşturan kullanım senaryosu.
class CreateBookingUseCase {
  final BookingRepositoryInterface repository;

  const CreateBookingUseCase(this.repository);

  Future<void> call(BookingRequest booking) {
    return repository.addBooking(booking);
  }
}
