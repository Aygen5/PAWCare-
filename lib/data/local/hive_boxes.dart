import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

class HiveBoxes {
  static const String dogsBox = 'dogs_box';
  static const String bookingsBox = 'bookings_box';
  static const String notificationsBox = 'notifications_box';
  static const String settingsBox = 'settings_box';

  /// Hive adaptörlerini kaydeder ve gerekli kutuları açar.
  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();

    await Hive.openBox<Dog>(dogsBox);
    await Hive.openBox<BookingRequest>(bookingsBox);
    await Hive.openBox<NotificationItem>(notificationsBox);
    await Hive.openBox<dynamic>(settingsBox);

    await _seedInitialDataIfNeeded();
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserRoleAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VaccineStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(VaccinationAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DogAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(SitterListingAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(BookingStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(BookingRequestAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(NotificationItemAdapter());
    }
  }

  static Box<Dog> get dogs => Hive.box<Dog>(dogsBox);
  static Box<BookingRequest> get bookings =>
      Hive.box<BookingRequest>(bookingsBox);
  static Box<NotificationItem> get notifications =>
      Hive.box<NotificationItem>(notificationsBox);
  static Box<dynamic> get settings => Hive.box<dynamic>(settingsBox);

  /// İlk açılışta kutular boşsa başlangıç demo verilerini yükler.
  static Future<void> _seedInitialDataIfNeeded() async {
    // Varsayılan köpek profili (Barley)
    if (dogs.isEmpty) {
      final defaultDog = Dog(
        id: 'dog_1',
        name: 'Barley',
        breed: 'Golden Retriever',
        ageYears: 2,
        weightKg: 28.5,
        gender: 'Erkek',
        microchip: '900215002941842',
        photoPath: 'assets/images/barley.jpg',
        allergyNote:
            'Tavuk proteini alerjisi — Yalnızca kuzu etli mama veriniz.',
        behaviorNote: 'İnsanlara ve diğer köpeklere karşı son derece uysal, oyuncu ve enerjik.',
        clinicName: 'Kadıköy Veteriner Polikliniği',
        clinicPhone: '+90 216 345 67 89',
        vaccinations: [
          Vaccination(
            id: 'v_1',
            title: 'Karma Aşı (DHPPi+L)',
            dueDate: '26 Ekim 2026',
            status: VaccineStatus.upcoming,
            vetName: 'Dr. Selin Bulut',
          ),
          Vaccination(
            id: 'v_2',
            title: 'Kuduz Aşısı (Rabies)',
            dueDate: '14 Haziran 2026',
            status: VaccineStatus.completed,
            vetName: 'Dr. Selin Bulut',
            completionDate: '14 Haziran 2026',
          ),
          Vaccination(
            id: 'v_3',
            title: 'İç & Dış Parazit Tedavisi',
            dueDate: '02 Eylül 2026',
            status: VaccineStatus.completed,
            vetName: 'Dr. Selin Bulut',
            completionDate: '02 Eylül 2026',
          ),
          Vaccination(
            id: 'v_4',
            title: 'Kennel Cough (Bronşin)',
            dueDate: '15 Kasım 2026',
            status: VaccineStatus.upcoming,
            vetName: 'Dr. Selin Bulut',
          ),
        ],
      );
      await dogs.put(defaultDog.id, defaultDog);
    }

    // Varsayılan rezervasyonlar
    if (bookings.isEmpty) {
      final defaultBookings = [
        BookingRequest(
          id: 'book_101',
          sitterId: 'sitter_1',
          sitterName: 'Ayşe Yılmaz',
          sitterPhoto: 'assets/images/ayse.jpg',
          petName: 'Barley',
          petBreed: 'Golden Retriever',
          serviceTitle: 'Köpek Oteli — 2 Gece Konaklama',
          startDate: DateTime(2026, 10, 24),
          endDate: DateTime(2026, 10, 26),
          totalPrice: 950.0,
          careNotes: 'Barley tavuk alerjisine sahip, kendi maması çantada teslim edilecektir. Akşam 19:00 civarı teslim edeceğiz.',
          status: BookingStatus.pending,
        ),
        BookingRequest(
          id: 'book_100',
          sitterId: 'sitter_2',
          sitterName: 'Mert Demir',
          sitterPhoto: 'assets/images/mert.jpg',
          petName: 'Barley',
          petBreed: 'Golden Retriever',
          serviceTitle: 'Caddebostan Sahil Parkı Yürüyüşü',
          startDate: DateTime(2026, 10, 23, 14, 0),
          endDate: DateTime(2026, 10, 23, 15, 0),
          totalPrice: 250.0,
          careNotes: 'Tempolu sahil yürüyüşü, bol su molası.',
          status: BookingStatus.confirmed,
        ),
      ];

      for (final booking in defaultBookings) {
        await bookings.put(booking.id, booking);
      }
    }

    // Varsayılan bildirimler
    if (notifications.isEmpty) {
      final defaultNotifications = [
        NotificationItem(
          id: 'notif_1',
          title: 'Rezervasyon Onaylandı! 🐾',
          body: 'Mert Demir ile 23 Ekim tarihli yürüyüş seansınız onaylandı.',
          timestamp: DateTime(2026, 10, 23, 13, 0),
          isRead: false,
          type: 'booking',
        ),
        NotificationItem(
          id: 'notif_2',
          title: 'Aşı Hatırlatması 💉',
          body: 'Karma Aşı (DHPPi+L) için randevu tarihiniz yaklaşıyor (26 Ekim).',
          timestamp: DateTime(2026, 10, 22, 10, 30),
          isRead: true,
          type: 'vaccine',
        ),
      ];

      for (final notif in defaultNotifications) {
        await notifications.put(notif.id, notif);
      }
    }
  }
}
