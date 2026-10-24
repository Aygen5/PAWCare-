import 'package:hive/hive.dart';

import '../../domain/repositories/booking_repository_interface.dart';
import '../local/hive_boxes.dart';
import '../models/models.dart';

class BookingRepository implements BookingRepositoryInterface {
  /// Başlangıç tarihine göre sıralı tüm rezervasyonları getirir.
  @override
  List<BookingRequest> getAllBookings() {
    try {
      if (!Hive.isBoxOpen(HiveBoxes.bookingsBox)) return [];
      final list = HiveBoxes.bookings.values.toList();
      list.sort((a, b) => b.startDate.compareTo(a.startDate));
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Belirli bir duruma göre filtrelenmiş rezervasyonları getirir.
  @override
  List<BookingRequest> getBookingsByStatus(BookingStatus status) {
    return getAllBookings().where((b) => b.status == status).toList();
  }

  /// Yeni bir rezervasyon talebi ekler.
  @override
  Future<void> addBooking(covariant BookingRequest booking) async {
    await HiveBoxes.bookings.put(booking.id, booking);
  }

  /// Rezervasyonun durumunu (onaylandı/reddedildi/tamamlandı) günceller.
  @override
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    final booking = HiveBoxes.bookings.get(bookingId);
    if (booking != null) {
      final updated = booking.copyWith(status: newStatus);
      await HiveBoxes.bookings.put(bookingId, updated);
    }
  }

  /// Bir rezervasyon kaydını siler.
  @override
  Future<void> deleteBooking(String bookingId) async {
    await HiveBoxes.bookings.delete(bookingId);
  }
}
