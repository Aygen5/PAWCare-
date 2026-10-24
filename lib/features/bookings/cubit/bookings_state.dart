import '../../../domain/entities/booking.dart';

/// Rezervasyon listesi filtre türleri.
enum BookingFilter { all, pending, confirmed, past }

/// Rezervasyon listesi yükleme durumu.
enum BookingsStatus { initial, loading, loaded, error }

/// Rezervasyonlarım sekmesi durum modeli.
class BookingsState {
  final BookingsStatus status;
  final List<BookingRequest> allBookings;
  final List<BookingRequest> filteredBookings;
  final BookingFilter activeFilter;
  final String? errorMessage;
  final String? cancellingBookingId;

  const BookingsState({
    this.status = BookingsStatus.initial,
    this.allBookings = const [],
    this.filteredBookings = const [],
    this.activeFilter = BookingFilter.all,
    this.errorMessage,
    this.cancellingBookingId,
  });

  bool get isLoading => status == BookingsStatus.loading;
  bool get isLoaded => status == BookingsStatus.loaded;
  bool get isError => status == BookingsStatus.error;

  int get pendingCount =>
      allBookings.where((b) => b.status == BookingStatus.pending).length;

  int get confirmedCount =>
      allBookings.where((b) => b.status == BookingStatus.confirmed).length;

  BookingsState copyWith({
    BookingsStatus? status,
    List<BookingRequest>? allBookings,
    List<BookingRequest>? filteredBookings,
    BookingFilter? activeFilter,
    String? errorMessage,
    String? cancellingBookingId,
  }) {
    return BookingsState(
      status: status ?? this.status,
      allBookings: allBookings ?? this.allBookings,
      filteredBookings: filteredBookings ?? this.filteredBookings,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage,
      cancellingBookingId: cancellingBookingId,
    );
  }
}
