import '../local/hive_boxes.dart';
import '../models/models.dart';

class DogRepository {
  /// Birincil köpek profilini getirir (varsayılan 'dog_1' veya ilk kayıt).
  Dog? getCurrentDog() {
    if (HiveBoxes.dogs.isEmpty) return null;
    return HiveBoxes.dogs.get('dog_1') ?? HiveBoxes.dogs.values.first;
  }

  /// Köpek profilini Hive veritabanına kaydeder veya günceller.
  Future<void> saveDog(Dog dog) async {
    await HiveBoxes.dogs.put(dog.id, dog);
  }

  /// Belirli bir köpeğe yeni aşı kaydı ekler.
  Future<void> addVaccination(String dogId, Vaccination vaccination) async {
    final dog = HiveBoxes.dogs.get(dogId);
    if (dog != null) {
      final updatedVaccinations = List<Vaccination>.from(dog.vaccinations)
        ..add(vaccination);
      final updatedDog = dog.copyWith(vaccinations: updatedVaccinations);
      await saveDog(updatedDog);
    }
  }

  /// Aşının durumunu günceller.
  Future<void> updateVaccinationStatus(
    String dogId,
    String vaccinationId,
    VaccineStatus newStatus, {
    String? completionDate,
  }) async {
    final dog = HiveBoxes.dogs.get(dogId);
    if (dog != null) {
      final updatedVaccinations = dog.vaccinations.map((v) {
        if (v.id == vaccinationId) {
          return v.copyWith(
            status: newStatus,
            completionDate: completionDate ?? v.completionDate,
          );
        }
        return v;
      }).toList();

      final updatedDog = dog.copyWith(vaccinations: updatedVaccinations);
      await saveDog(updatedDog);
    }
  }
}
