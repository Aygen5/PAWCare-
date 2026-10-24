import '../../entities/sitter.dart';
import '../../repositories/sitter_repository_interface.dart';

/// Sistemdeki tüm bakıcıları getiren kullanım senaryosu (Use Case).
class GetSittersUseCase {
  final SitterRepositoryInterface repository;

  const GetSittersUseCase(this.repository);

  Future<List<SitterListing>> call({bool forceRefresh = false}) {
    return repository.getSitters(forceRefresh: forceRefresh);
  }
}
