import '../../entities/sitter.dart';
import '../../repositories/sitter_repository_interface.dart';

/// Bakıcıları kategori ve arama filtresine göre getiren kullanım senaryosu (Use Case).
class SearchSittersUseCase {
  final SitterRepositoryInterface repository;

  const SearchSittersUseCase(this.repository);

  Future<List<SitterListing>> call({
    String category = 'Tümü',
    String query = '',
  }) {
    return repository.searchSitters(category: category, query: query);
  }
}
