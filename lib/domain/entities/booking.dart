/// Rezervasyon durumunu temsil eden enum.
enum BookingStatus { pending, confirmed, rejected, completed }

/// Rezervasyon talebini ve detaylarını temsil eden saf iş alanı varlığı (Entity).
class BookingRequest {
  final String id;
  final String sitterId;
  final String sitterName;
  final String sitterPhoto;
  final String petName;
  final String petBreed;
  final String serviceTitle;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String careNotes;
  final BookingStatus status;

  const BookingRequest({
    required this.id,
    required this.sitterId,
    required this.sitterName,
    required this.sitterPhoto,
    required this.petName,
    required this.petBreed,
    required this.serviceTitle,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.careNotes,
    this.status = BookingStatus.pending,
  });

  BookingRequest copyWith({
    String? id,
    String? sitterId,
    String? sitterName,
    String? sitterPhoto,
    String? petName,
    String? petBreed,
    String? serviceTitle,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? careNotes,
    BookingStatus? status,
  }) {
    return BookingRequest(
      id: id ?? this.id,
      sitterId: sitterId ?? this.sitterId,
      sitterName: sitterName ?? this.sitterName,
      sitterPhoto: sitterPhoto ?? this.sitterPhoto,
      petName: petName ?? this.petName,
      petBreed: petBreed ?? this.petBreed,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      careNotes: careNotes ?? this.careNotes,
      status: status ?? this.status,
    );
  }
}
