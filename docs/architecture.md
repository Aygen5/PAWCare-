# PawCare — Mimari ve Klasör Yapısı (Clean Architecture)

## 1. Mimari Yaklaşım

PawCare projesinde **Clean Architecture (Temiz Mimari) + Feature-First** yaklaşımı benimsenmiştir. Proje; Presentation (Sunum), Domain (İş Alanı) ve Data (Veri) olmak üzere üç temel katmana ayrılmıştır:

- **Presentation Katmanı (`features/`, `app/`):** Kullanıcı arayüzünü (View/Widget), rota yönetimini (GoRouter) ve durum yönetimini (Cubit/BLoC) barındırır.
- **Domain Katmanı (`domain/`):** Uygulamanın çekirdeğidir. Saf Dart nesnelerinden oluşur; Flutter SDK, UI, Hive veya JSON gibi altyapı detaylarından tamamen bağımsızdır. Varlıklar (Entities), Kullanım Senaryoları (UseCases) ve Repository Sözleşmelerini (Interfaces) içerir.
- **Data Katmanı (`data/`):** Domain katmanındaki sözleşmeleri uygulayan somut sınıfları, veri modellerini/DTO'ları (Hive TypeAdapter, JSON dönüşümleri) ve yerel/uzak veri kaynaklarını (Hive kutuları, SharedPreferences, JSON dosyaları) barındırır.

### Veri ve Bağımlılık Akışı

```text
[ Presentation ] ─────────► [ Domain ] ◄───────── [ Data ]
 (View / Cubit)             (Entity)              (Model / DTO)
        │                 (UseCase)                     ▲
        ▼                     │                         │
[UseCase Çağrısı] ────► [Repository Interface] ◄── [Repository Impl]
                                                        │
                                                        ▼
                                                [Data Sources]
                                            (Hive / JSON / SharedPrefs)
```

**Kritik Bağımlılık Kuralı:** Bağımlılıklar içe, yani **Domain** katmanına doğru yönelir. Domain katmanı ne Presentation'ı ne de Data katmanını import eder.

---

## 2. Mevcut ve Gerçek Klasör Yapısı

Aşağıdaki ağaç projedeki gerçek dosya ve klasör yapısını birebir yansıtmaktadır:

```text
lib/
  main.dart
  app/
    app.dart
    router/
      app_router.dart
      route_names.dart
      app_shell.dart
  core/
    constants/
      app_constants.dart
    theme/
      app_colors.dart
      app_theme.dart
      app_typography.dart
      theme_cubit.dart
    utils/
      app_state.dart
      image_storage_service.dart
    widgets/
      paw_bottom_nav.dart
      paw_header_actions.dart
  domain/
    domain.dart
    entities/
      entities.dart
      user_role.dart
      vaccination.dart
      dog.dart
      sitter.dart
      booking.dart
      notification.dart
      chat_message.dart
    repositories/
      repositories.dart
      sitter_repository_interface.dart
      booking_repository_interface.dart
      dog_repository_interface.dart
      notification_repository_interface.dart
      settings_repository_interface.dart
    usecases/
      usecases.dart
      sitter/
        get_sitters_use_case.dart
        search_sitters_use_case.dart
      booking/
        get_bookings_use_case.dart
        create_booking_use_case.dart
        manage_booking_status_use_case.dart
      pet/
        get_dog_profile_use_case.dart
        add_vaccination_use_case.dart
      notification/
        get_notifications_use_case.dart
        mark_notification_read_use_case.dart
      settings/
        get_app_settings_use_case.dart
        update_app_settings_use_case.dart
  data/
    local/
      hive_boxes.dart
    models/
      models.dart
      models.g.dart
    repositories/
      booking_repository.dart
      dog_repository.dart
      notification_repository.dart
      settings_repository.dart
      sitter_repository.dart
  features/
    onboarding/
      view/welcome_screen.dart
      cubit/
      widgets/
    auth/
      view/
      cubit/auth_cubit.dart, role_cubit.dart
      widgets/login_modal.dart, signup_modal.dart
    home/
      view/owner_home_screen.dart
      cubit/
      widgets/chat_modal.dart, live_tracking_modal.dart
    discovery/
      view/explore_screen.dart, sitter_detail_screen.dart
      cubit/
      widgets/call_modal.dart
    pets/
      view/dog_profile_screen.dart
      cubit/
      widgets/health_card_modal.dart
    bookings/
      view/
      cubit/
      widgets/
    provider/
      view/sitter_dashboard_screen.dart
      cubit/
      widgets/
    profile/
      view/
      cubit/
      widgets/
    notifications/
      view/
      cubit/
      widgets/
    splash/
      view/splash_page.dart
      cubit/splash_cubit.dart
      widgets/
assets/
  images/
  data/
test/
```

---

## 3. Katman Sorumlulukları

- `main.dart`: Flutter motoru ve Hive servislerinin başlatılması; bağımlılıkların oluşturulup uygulamanın ayağa kaldırılması.
- `app/`: Uygulama kök widget'ı (`PawCareApp`), tema bağlantısı ve GoRouter rota yapılandırması.
- `core/`: Tema token'ları (renk, tipografi, ThemeData), genel sabitler, ortak yardımcı servisler ve genel UI bileşenleri.
- `domain/`: İş alanının kalbi. Saf Dart varlıkları (Entities), kullanım senaryoları (UseCases) ve repository arayüzleri (Interfaces).
- `data/`: Hive modelleri, TypeAdapter'lar, JSON serileştirme ve Domain sözleşmelerini uygulayan somut Repository sınıfları.
- `features/`: Özellik bazlı modüller; her özellik kendi View, Cubit ve Widget bileşenlerini barındırır.
- `assets/`: Yerel görseller, ikonlar ve başlangıç JSON verileri (`sitters.json`).
- `test/`: Entity, UseCase, Repository, Cubit, Rota ve UI widget testleri.

---

## 4. Domain Katmanı ve Bileşenleri

1. **Entities (`lib/domain/entities/`):**
   - Saf Dart sınıfları ve enum'larıdır.
   - Harici paket bağımlılığı (Hive, Flutter UI vb.) içermez.
   - Örnekler: `UserRole`, `VaccineStatus`, `Vaccination`, `Dog`, `SitterListing`, `BookingStatus`, `BookingRequest`, `NotificationItem`, `ChatMessage`.
2. **Repository Arayüzleri (`lib/domain/repositories/`):**
   - Verinin nereden geldiğini (Hive, API, JSON, SharedPreferences) bilmeden yalnızca ihtiyaç duyulan metod imzalarını tanımlayan soyut (`abstract`) sözleşmelerdir.
   - Örnekler: `SitterRepositoryInterface`, `BookingRepositoryInterface`, `DogRepositoryInterface`, `NotificationRepositoryInterface`, `SettingsRepositoryInterface`.
3. **Use Cases (`lib/domain/usecases/`):**
   - Uygulamanın tekil iş kurallarını temsil eden sınıflardır. Yalnızca ilgili Repository arayüzüne bağımlıdır.
   - Örnekler:
     - `GetSittersUseCase`, `SearchSittersUseCase`
     - `GetBookingsUseCase`, `CreateBookingUseCase`, `ManageBookingStatusUseCase`
     - `GetDogProfileUseCase`, `AddVaccinationUseCase`
     - `GetNotificationsUseCase`, `MarkNotificationReadUseCase`
     - `GetAppSettingsUseCase`, `UpdateAppSettingsUseCase`

---

## 5. Data Katmanı ve Bileşenleri

1. **Model / DTO (`lib/data/models/`):**
   - Domain varlıklarını genişleten (`implements entity.X`) ve Hive TypeAdapter anotasyonları (`@HiveType`, `@HiveField`) ile `fromJson`/`toJson` dönüşümlerini üstlenen sınıflardır.
   - Domain katmanına bağımlıdır (`Data → Domain`), ancak Domain katmanı bunlardan habersizdir.
2. **Local Data Source (`lib/data/local/`):**
   - `HiveBoxes`: Hive veritabanı kutularının açılması, kapatılması ve tip adaptörlerinin kaydedilmesi işlemlerini yürütür.
3. **Repository İmplementasyonları (`lib/data/repositories/`):**
   - Domain katmanındaki sözleşmeleri (`implements ...Interface`) uygular.
   - `SitterRepository`: `assets/data/sitters.json` dosyasından veriyi okur ve önbelleğe alır.
   - `BookingRepository`: `HiveBoxes.bookings` kutusu üzerinden CRUD işlemlerini gerçekleştirir.
   - `DogRepository`: `HiveBoxes.dogs` kutusu üzerinde profil ve aşı kayıtlarını yönetir.
   - `NotificationRepository`: `HiveBoxes.notifications` kutusunu yönetir.
   - `SettingsRepository`: `SharedPreferences` ve bellek içi depolama ile tema/rol/tanıtım durumunu saklar.

---

## 6. Mimari Kurallar ve Bağımlılık Yönü

1. **Tersine Bağımlılık (Dependency Inversion):** Presentation katmanındaki Cubit'ler ve UseCase'ler, somut repository sınıfları yerine `SettingsRepositoryInterface`, `SitterRepositoryInterface` gibi Domain sözleşmelerine bağlanır.
2. **Saf Domain:** `lib/domain/` altındaki hiçbir dosya `flutter/material.dart`, `package:hive/` veya `package:paw_care/data/` import edemez.
3. **Çoklu Kaynak Yasağı:** Aynı veri türü için birden fazla bağımsız kaynak oluşturulmaz; rezervasyon, köpek profili ve bakıcı verilerinin tekil kaynağı ilgili repository'dir.
4. **Kademeli Geçiş:** Mevcut ekranlar çalışmaya devam ederken, durum ve veri akışları adım adım UseCase ve Repository sözleşmelerine devredilir.

---

## 7. Veri Saklama Yaklaşımı

- **SharedPreferences:** Hafif ayarlar (Aktif tema: `light`/`dark`/`system`, Kullanıcı rolü: `owner`/`sitter`, Tanıtım durumu: `hasSeenOnboarding`).
- **Hive:** Yapılandırılmış nesneler (Köpek profili, Aşı kayıtları, Rezervasyon talepleri, Bildirimler).
- **Yerel JSON:** Başlangıç verileri (`assets/data/sitters.json`).

---

## 8. Henüz Uygulanmamış veya Geçişi Devam Eden Alanlar

- Ekranların içindeki bazı yerel mock durumlar (`AppState`) tamamen Cubit + UseCase akışına taşınma aşamasındadır (Faz 4 ve Faz 5 kapsamında tamamlanacaktır).
- Uzak API bağlantısı (REST/GraphQL) henüz bulunmamaktadır; tüm veriler yerel veri kaynakları (Hive, JSON, SharedPreferences) üzerinden yönetilmektedir.
- Rezervasyon oluşturma, profil düzenleme ve bildirim dinleme özellikleri Faz 5 ve Faz 6 adımlarında Domain UseCase'leri üzerinden UI ile tam entegre edilecektir.