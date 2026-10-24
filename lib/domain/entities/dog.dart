import 'vaccination.dart';

/// Köpek profilini ve sağlık geçmişini temsil eden saf iş alanı varlığı (Entity).
class Dog {
  final String id;
  final String name;
  final String breed;
  final int ageYears;
  final double weightKg;
  final String gender;
  final String microchip;
  final String photoPath;
  final String allergyNote;
  final String behaviorNote;
  final String clinicName;
  final String clinicPhone;
  final List<Vaccination> vaccinations;

  const Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.ageYears,
    required this.weightKg,
    required this.gender,
    required this.microchip,
    required this.photoPath,
    required this.allergyNote,
    required this.behaviorNote,
    required this.clinicName,
    required this.clinicPhone,
    required this.vaccinations,
  });

  Dog copyWith({
    String? id,
    String? name,
    String? breed,
    int? ageYears,
    double? weightKg,
    String? gender,
    String? microchip,
    String? photoPath,
    String? allergyNote,
    String? behaviorNote,
    String? clinicName,
    String? clinicPhone,
    List<Vaccination>? vaccinations,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      microchip: microchip ?? this.microchip,
      photoPath: photoPath ?? this.photoPath,
      allergyNote: allergyNote ?? this.allergyNote,
      behaviorNote: behaviorNote ?? this.behaviorNote,
      clinicName: clinicName ?? this.clinicName,
      clinicPhone: clinicPhone ?? this.clinicPhone,
      vaccinations: vaccinations ?? this.vaccinations,
    );
  }
}
