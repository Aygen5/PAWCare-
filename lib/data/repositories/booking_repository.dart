import '../local/hive_boxes.dart';
import '../models/models.dart';

class BookingRepository {
  /// Başlangıç tarihine göre sıralı tüm rezervasyonları getirir.
  List<BookingRequest> getAllBookings() {
    final list = HiveBoxes.bookings.values.toList();
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
    return list;
  }

  /// Belirli bir duruma göre filtrelenmiş rezervasyonları getirir.
  List<BookingRequest> getBookingsByStatus(BookingStatus status) {
    return getAllBookings().where((b) => b.status == status).toList();
  }

  /// Yeni bir rezervasyon talebi ekler.
  Future<void> addBooking(BookingRequest booking) async {
    await HiveBoxes.bookings.put(booking.id, booking);
  }

  /// Rezervasyonun durumunu (onaylandı/reddedildi/tamamlandı) günceller.
  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    final booking = HiveBoxes.bookings.get(bookingId);
    if (booking != null) {
      final updated = booking.copyWith(status: newStatus);
      await HiveBoxes.bookings.put(bookingId, updated);
    }
  }

  /// Bir rezervasyon kaydını siler.
  Future<void> deleteBooking(String bookingId) async {
    await HiveBoxes.bookings.delete(bookingId);
  }
}
