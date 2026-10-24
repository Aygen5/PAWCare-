import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/booking_repository.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/repositories/booking_repository_interface.dart';
import '../../../domain/usecases/booking/get_bookings_use_case.dart';
import '../../../domain/usecases/booking/manage_booking_status_use_case.dart';
import 'provider_state.dart';

/// Hizmet veren (sitter) panelinin rezervasyon ve kazanç durumunu yöneten Clean Architecture Cubit'i.
class ProviderCubit extends Cubit<ProviderState> {
  final GetBookingsUseCase _getBookingsUseCase;
  final ManageBookingStatusUseCase _manageBookingStatusUseCase;

  ProviderCubit({
    GetBookingsUseCase? getBookingsUseCase,
    ManageBookingStatusUseCase? manageBookingStatusUseCase,
    BookingRepositoryInterface? bookingRepository,
    List<BookingRequest>? initialBookings,
  }) : _getBookingsUseCase =
           getBookingsUseCase ??
           GetBookingsUseCase(bookingRepository ?? BookingRepository()),
       _manageBookingStatusUseCase =
           manageBookingStatusUseCase ??
           ManageBookingStatusUseCase(bookingRepository ?? BookingRepository()),
       super(const ProviderState()) {
    if (initialBookings != null && initialBookings.isNotEmpty) {
      _emitBookings(initialBookings);
    } else {
      loadDashboard();
    }
  }

  /// Tüm rezervasyonları veritabanından çeker ve bekleyen/onaylı listeleri günceller.
  void loadDashboard({List<BookingRequest>? fallbackBookings}) {
    try {
      emit(state.copyWith(status: ProviderStatus.loading));
      var allBookings = _getBookingsUseCase.call();
      if (allBookings.isEmpty &&
          fallbackBookings != null &&
          fallbackBookings.isNotEmpty) {
        allBookings = fallbackBookings;
      }
      _emitBookings(allBookings);
    } catch (e) {
      if (fallbackBookings != null && fallbackBookings.isNotEmpty) {
        _emitBookings(fallbackBookings);
      } else {
        emit(
          state.copyWith(
            status: ProviderStatus.error,
            errorMessage: 'Talepler yüklenirken bir hata oluştu: $e',
          ),
        );
      }
    }
  }

  /// Rezervasyon listesini filtreleyerek durumları ve kazancı hesaplar.
  void _emitBookings(List<BookingRequest> allBookings) {
    final pending = allBookings
        .where((b) => b.status == BookingStatus.pending)
        .toList();
    final confirmed = allBookings
        .where((b) => b.status == BookingStatus.confirmed)
        .toList();

    // Onaylı rezervasyonların toplam tutarı veya demo baz kazanç
    final earnings = confirmed.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    emit(
      state.copyWith(
        status: ProviderStatus.loaded,
        bookings: allBookings,
        pendingBookings: pending,
        confirmedBookings: confirmed,
        totalEarnings: earnings > 0 ? earnings : 4250.0,
        errorMessage: null,
        updatingBookingId: null,
      ),
    );
  }

  /// Bekleyen bir rezervasyonu onaylar ve durumu günceller.
  Future<bool> confirmBooking(String bookingId) async {
    try {
      emit(state.copyWith(updatingBookingId: bookingId));
      await _manageBookingStatusUseCase.updateStatus(
        bookingId,
        BookingStatus.confirmed,
      );
      loadDashboard();
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updatingBookingId: null,
          errorMessage: 'Rezervasyon onaylanırken hata oluştu: $e',
        ),
      );
      return false;
    }
  }

  /// Bekleyen bir rezervasyonu reddeder ve durumu günceller.
  Future<bool> rejectBooking(String bookingId) async {
    try {
      emit(state.copyWith(updatingBookingId: bookingId));
      await _manageBookingStatusUseCase.updateStatus(
        bookingId,
        BookingStatus.rejected,
      );
      loadDashboard();
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updatingBookingId: null,
          errorMessage: 'Rezervasyon reddedilirken hata oluştu: $e',
        ),
      );
      return false;
    }
  }
}
