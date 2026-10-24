import '../entities/sitter.dart';

/// Bakıcı verilerine erişim kurallarını ve işlemlerini tanımlayan soyut Domain sözleşmesi.
abstract class SitterRepositoryInterface {
  /// Sistemdeki tüm bakıcı listesini getirir.
  Future<List<SitterListing>> getSitters({bool forceRefresh = false});

  /// Bakıcıları kategori ve arama filtresine göre arar.
  Future<List<SitterListing>> searchSitters({
    String category = 'Tümü',
    String query = '',
  });

  /// ID bilgisi verilen bakıcının detayını döner.
  Future<SitterListing?> getSitterById(String id);
}
