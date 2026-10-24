import '../../entities/vaccination.dart';
import '../../repositories/dog_repository_interface.dart';

/// Köpeğe yeni aşı ekleme ve durumunu güncelleme işlemlerini yürüten kullanım senaryosu.
class AddVaccinationUseCase {
  final DogRepositoryInterface repository;

  const AddVaccinationUseCase(this.repository);

  Future<void> call(String dogId, Vaccination vaccination) {
    return repository.addVaccination(dogId, vaccination);
  }

  Future<void> addVaccine(String dogId, Vaccination vaccination) {
    return repository.addVaccination(dogId, vaccination);
  }

  Future<void> updateStatus(
    String dogId,
    String vaccinationId,
    VaccineStatus newStatus, {
    String? completionDate,
  }) {
    return repository.updateVaccinationStatus(
      dogId,
      vaccinationId,
      newStatus,
      completionDate: completionDate,
    );
  }
}
