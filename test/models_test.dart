import 'package:flutter_test/flutter_test.dart';
import 'package:paw_care/data/models/models.dart';

void main() {
  group('PawCare Models & Serialization Tests', () {
    test('Dog model serialization and copyWith works correctly', () {
      final vaccination = Vaccination(
        id: 'v_1',
        title: 'Karma Aşı (DHPPi+L)',
        dueDate: '26 Ekim 2026',
        status: VaccineStatus.upcoming,
        vetName: 'Dr. Selin Bulut',
      );

      final dog = Dog(
        id: 'dog_1',
        name: 'Barley',
        breed: 'Golden Retriever',
        ageYears: 2,
        weightKg: 28.5,
        gender: 'Erkek',
        microchip: '900215002941842',
        photoPath: 'assets/images/barley.jpg',
        allergyNote: 'Tavuk proteini alerjisi',
        behaviorNote: 'Uysal ve oyuncu',
        clinicName: 'Kadıköy Vet',
        clinicPhone: '+90 216 111 22 33',
        vaccinations: [vaccination],
      );

      // JSON serileştirme ve geri dönüştürme doğrulaması
      final json = dog.toJson();
      final restored = Dog.fromJson(json);

      expect(restored.id, dog.id);
      expect(restored.name, dog.name);
      expect(restored.breed, dog.breed);
      expect(restored.weightKg, dog.weightKg);
      expect(restored.vaccinations.length, 1);
      expect(restored.vaccinations.first.title, vaccination.title);

      // Model kopyalama ve alan güncelleme testi
      final updatedDog = dog.copyWith(name: 'Barley Jr.', weightKg: 29.0);
      expect(updatedDog.name, 'Barley Jr.');
      expect(updatedDog.weightKg, 29.0);
      expect(updatedDog.id, dog.id);
    });

    test('SitterListing model serialization works correctly', () {
      final sitter = SitterListing(
        id: 'sitter_1',
        name: 'Ayşe Yılmaz',
        facilityTitle: 'Mutlu Patiler Butik Köpek Oteli',
        category: 'Köpek Oteli',
        rating: 4.9,
        reviewsCount: 128,
        pricePerUnit: 450.0,
        unitLabel: 'gece',
        location: 'Caddebostan, Kadıköy',
        distanceKm: 1.2,
        imagePath: 'assets/images/ayse.jpg',
        galleryPaths: ['assets/images/hotel_garden.jpg'],
        bio: '7 yıldır profesyonel bakım uzmanı.',
        amenities: ['Geniş Çim Bahçe', '7/24 Kamera Takibi'],
        isVerified: true,
      );

      final json = sitter.toJson();
      final restored = SitterListing.fromJson(json);

      expect(restored.id, sitter.id);
      expect(restored.name, sitter.name);
      expect(restored.pricePerUnit, 450.0);
      expect(restored.amenities.length, 2);
      expect(restored.isVerified, true);
    });

    test('BookingRequest and ChatMessage serialization works correctly', () {
      final now = DateTime(2026, 10, 24, 10, 0);
      final booking = BookingRequest(
        id: 'b_101',
        sitterId: 'sitter_1',
        sitterName: 'Ayşe Yılmaz',
        sitterPhoto: 'assets/images/ayse.jpg',
        petName: 'Barley',
        petBreed: 'Golden Retriever',
        serviceTitle: 'Köpek Oteli',
        startDate: now,
        endDate: now.add(const Duration(days: 2)),
        totalPrice: 900.0,
        careNotes: 'Alerji notu.',
        status: BookingStatus.pending,
      );

      final bookingJson = booking.toJson();
      final restoredBooking = BookingRequest.fromJson(bookingJson);
      expect(restoredBooking.id, booking.id);
      expect(restoredBooking.status, BookingStatus.pending);
      expect(restoredBooking.totalPrice, 900.0);

      final chat = ChatMessage(
        id: 'm1',
        senderName: 'Mert',
        text: 'Merhaba!',
        time: '14:02',
        isMe: false,
      );
      final chatJson = chat.toJson();
      final restoredChat = ChatMessage.fromJson(chatJson);
      expect(restoredChat.id, chat.id);
      expect(restoredChat.text, 'Merhaba!');
      expect(restoredChat.isMe, false);
    });
  });
}
