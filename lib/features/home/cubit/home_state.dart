import '../../../data/models/models.dart';

/// Ana sayfa durumunun yüklenme aşamalarını temsil eder.
enum HomeStatus { initial, loading, loaded, error }

/// Köpek Sahibi Ana Sayfasının durum sınıfı.
class HomeState {
  final HomeStatus status;
  final Dog? dog;
  final BookingRequest? activeBooking;
  final List<BookingRequest> upcomingBookings;
  final List<SitterListing> featuredSitters;
  final Vaccination? upcomingVaccine;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.dog,
    this.activeBooking,
    this.upcomingBookings = const [],
    this.featuredSitters = const [],
    this.upcomingVaccine,
    this.errorMessage,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get isError => status == HomeStatus.error;

  HomeState copyWith({
    HomeStatus? status,
    Dog? dog,
    BookingRequest? activeBooking,
    List<BookingRequest>? upcomingBookings,
    List<SitterListing>? featuredSitters,
    Vaccination? upcomingVaccine,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dog: dog ?? this.dog,
      activeBooking: activeBooking ?? this.activeBooking,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      featuredSitters: featuredSitters ?? this.featuredSitters,
      upcomingVaccine: upcomingVaccine ?? this.upcomingVaccine,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
