import '../../../domain/entities/booking.dart';

/// Hizmet veren panelinin veri yükleme durumları.
enum ProviderStatus { initial, loading, loaded, error }

/// Hizmet veren paneli durum modeli.
class ProviderState {
  final ProviderStatus status;
  final List<BookingRequest> bookings;
  final List<BookingRequest> pendingBookings;
  final List<BookingRequest> confirmedBookings;
  final double totalEarnings;
  final String? errorMessage;
  final String? updatingBookingId;

  const ProviderState({
    this.status = ProviderStatus.initial,
    this.bookings = const [],
    this.pendingBookings = const [],
    this.confirmedBookings = const [],
    this.totalEarnings = 0.0,
    this.errorMessage,
    this.updatingBookingId,
  });

  bool get isLoading => status == ProviderStatus.loading;
  bool get isLoaded => status == ProviderStatus.loaded;
  bool get isError => status == ProviderStatus.error;

  ProviderState copyWith({
    ProviderStatus? status,
    List<BookingRequest>? bookings,
    List<BookingRequest>? pendingBookings,
    List<BookingRequest>? confirmedBookings,
    double? totalEarnings,
    String? errorMessage,
    String? updatingBookingId,
  }) {
    return ProviderState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      confirmedBookings: confirmedBookings ?? this.confirmedBookings,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      errorMessage: errorMessage,
      updatingBookingId: updatingBookingId,
    );
  }
}
