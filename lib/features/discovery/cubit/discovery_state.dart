import '../../../data/models/models.dart';

/// Keşfet ekranının yükleme aşamalarını temsil eder.
enum DiscoveryStatus { initial, loading, loaded, error }

/// Keşfet ve Hizmet Detayı özelliği durum sınıfı.
class DiscoveryState {
  final DiscoveryStatus status;
  final List<SitterListing> sitters;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;
  final bool isBookingSuccess;

  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.sitters = const [],
    this.selectedCategory = 'Tümü',
    this.searchQuery = '',
    this.errorMessage,
    this.isBookingSuccess = false,
  });

  bool get isLoading => status == DiscoveryStatus.loading;
  bool get isLoaded => status == DiscoveryStatus.loaded;
  bool get isError => status == DiscoveryStatus.error;

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    List<SitterListing>? sitters,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
    bool? isBookingSuccess,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      sitters: sitters ?? this.sitters,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      isBookingSuccess: isBookingSuccess ?? this.isBookingSuccess,
    );
  }
}
