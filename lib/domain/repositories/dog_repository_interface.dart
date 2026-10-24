import '../entities/dog.dart';
import '../entities/vaccination.dart';

/// Köpek profili ve sağlık verilerini yöneten soyut Domain sözleşmesi.
abstract class DogRepositoryInterface {
  /// Mevcut kayıtlı köpek profilini getirir.
  Dog? getCurrentDog();

  /// Köpek profil bilgilerini kaydeder veya günceller.
  Future<void> saveDog(Dog dog);

  /// Köpeğe yeni aşı veya sağlık randevusu ekler.
  Future<void> addVaccination(String dogId, Vaccination vaccination);

  /// Aşının durumunu günceller.
  Future<void> updateVaccinationStatus(
    String dogId,
    String vaccinationId,
    VaccineStatus newStatus, {
    String? completionDate,
  });
}
