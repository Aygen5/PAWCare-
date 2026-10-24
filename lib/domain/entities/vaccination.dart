/// Aşının veya sağlık işleminin durumunu ifade eden enum.
enum VaccineStatus { completed, upcoming, overdue }

/// Evcil hayvan aşı ve tedavi kaydını temsil eden saf iş alanı varlığı (Entity).
class Vaccination {
  final String id;
  final String title;
  final String dueDate;
  final VaccineStatus status;
  final String vetName;
  final String? completionDate;

  const Vaccination({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.vetName,
    this.completionDate,
  });

  Vaccination copyWith({
    String? id,
    String? title,
    String? dueDate,
    VaccineStatus? status,
    String? vetName,
    String? completionDate,
  }) {
    return Vaccination(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      vetName: vetName ?? this.vetName,
      completionDate: completionDate ?? this.completionDate,
    );
  }
}
