import '../../../data/models/models.dart';

/// Evcil hayvan profil ekranının yüklenme durumlarını temsil eder.
enum PetsStatus { initial, loading, loaded, error }

/// Köpek Profili ve Sağlık Yönetimi özellik durum sınıfı.
class PetsState {
  final PetsStatus status;
  final Dog? dog;
  final String? errorMessage;
  final bool isPhotoUpdating;

  const PetsState({
    this.status = PetsStatus.initial,
    this.dog,
    this.errorMessage,
    this.isPhotoUpdating = false,
  });

  bool get isLoading => status == PetsStatus.loading;
  bool get isLoaded => status == PetsStatus.loaded;
  bool get isError => status == PetsStatus.error;

  PetsState copyWith({
    PetsStatus? status,
    Dog? dog,
    String? errorMessage,
    bool? isPhotoUpdating,
  }) {
    return PetsState(
      status: status ?? this.status,
      dog: dog ?? this.dog,
      errorMessage: errorMessage ?? this.errorMessage,
      isPhotoUpdating: isPhotoUpdating ?? this.isPhotoUpdating,
    );
  }
}
