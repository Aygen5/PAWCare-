/// Bakıcı ilanını ve hizmet detaylarını temsil eden saf iş alanı varlığı (Entity).
class SitterListing {
  final String id;
  final String name;
  final String facilityTitle;
  final String category; // 'Köpek Oteli', 'Köpek Gezdirme', 'Gündüz Bakımı'
  final double rating;
  final int reviewsCount;
  final double pricePerUnit;
  final String unitLabel; // 'gece', 'saat', 'gün'
  final String location;
  final double distanceKm;
  final String imagePath;
  final List<String> galleryPaths;
  final String bio;
  final List<String> amenities;
  final bool isVerified;

  const SitterListing({
    required this.id,
    required this.name,
    required this.facilityTitle,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerUnit,
    required this.unitLabel,
    required this.location,
    required this.distanceKm,
    required this.imagePath,
    required this.galleryPaths,
    required this.bio,
    required this.amenities,
    this.isVerified = true,
  });

  SitterListing copyWith({
    String? id,
    String? name,
    String? facilityTitle,
    String? category,
    double? rating,
    int? reviewsCount,
    double? pricePerUnit,
    String? unitLabel,
    String? location,
    double? distanceKm,
    String? imagePath,
    List<String>? galleryPaths,
    String? bio,
    List<String>? amenities,
    bool? isVerified,
  }) {
    return SitterListing(
      id: id ?? this.id,
      name: name ?? this.name,
      facilityTitle: facilityTitle ?? this.facilityTitle,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unitLabel: unitLabel ?? this.unitLabel,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      imagePath: imagePath ?? this.imagePath,
      galleryPaths: galleryPaths ?? this.galleryPaths,
      bio: bio ?? this.bio,
      amenities: amenities ?? this.amenities,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
