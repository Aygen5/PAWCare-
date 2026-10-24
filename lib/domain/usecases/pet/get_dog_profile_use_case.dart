import '../../entities/dog.dart';
import '../../repositories/dog_repository_interface.dart';

/// Köpeğin mevcut profilini getiren veya profilini güncelleyen kullanım senaryosu.
class GetDogProfileUseCase {
  final DogRepositoryInterface repository;

  const GetDogProfileUseCase(this.repository);

  Dog? call() {
    return repository.getCurrentDog();
  }

  Future<void> saveProfile(Dog dog) {
    return repository.saveDog(dog);
  }
}
