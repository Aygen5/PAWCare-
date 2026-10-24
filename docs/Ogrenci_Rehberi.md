# PawCare — Öğrenci & Geliştirici Kapsamlı Mimari Rehberi

> Bu rehber; PawCare projesinin mimari tasarım kararlarını, yazılım prensiplerini, klasör hiyerarşisini, kullanılan Flutter teknolojilerini ve mülakatlarda karşınıza çıkabilecek kritik soruların cevaplarını detaylı ve öğretici bir dille açıklamak üzere hazırlanmıştır.



## 1. Mimari Temelleri: Hangi Mimariyi Neden Kullandık?

**Hibrit Mimari (Feature-First Presentation + Layer-First Clean Core)**.


1. **Saf Katman Odaklı (Layer-First) Yaklaşımın Sorunu:**  
   Eğer en üstte yalnızca `presentation/`, `domain/` ve `data/` klasörleri olsaydı; uygulamanız büyüdüğünde `presentation/views/` klasörünün altında 40-50 farklı ekran alt alta yığılacak, bir özellikle ilgili widget'ı veya controller'ı bulmak çileye dönüşecekti.
2. **Saf Özellik Odaklı (Feature-First) Yaklaşımın Sorunu:**  
   Eğer her özelliğin içine kendi `domain/` ve `data/` katmanını koysaydık; `Dog` (köpek profili), `Booking` (rezervasyon) veya `UserRole` (kullanıcı rolü) gibi birden fazla özelliği ilgilendiren ortak varlıklar için klasörler arası spagetti bağımlılıklar (cross-feature coupling) doğacaktı.
3. **PawCare'in Çözümü (En İyi Hibrit Mimari):**  
   - Kullanıcı Arayüzü (Presentation) tarafını **Feature-First** yaptık: `features/discovery`, `features/bookings`, `features/pets` vb. Her ekran kendi içinde bağımsız, modüler ve yönetilebilirdir.
   - İş Mantığı (Domain) ve Veri (Data) tarafını **Clean Architecture** prensipleriyle tek bir merkezde topladık: `lib/domain` ve `lib/data`.

Böylece UI geliştirirken modülerliğin rahatlığını yaşarken; veritabanı, modeller ve iş kurallarında tekil doğruluk kaynağını (Single Source of Truth) korumuş olduk.

---

### 1.2. Clean Architecture Katmanları ve Sorumlulukları

PawCare 3 ana katmandan ve 2 destek modülünden oluşur:

```text
┌─────────────────────────────────────────────────────────────┐
│                 PRESENTATION KATMANI                        │
│   (features/*, app/* — View, Widget, Cubit, GoRouter)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ UseCase çağırır
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   DOMAIN KATMANI (Çekirdek)                 │
│   (lib/domain/* — Saf Dart: Entities, UseCases, Interfaces) │
└──────────────────────────────▲──────────────────────────────┘
                               │ Arayüzleri uygular (implements)
┌──────────────────────────────┴──────────────────────────────┐
│                    DATA KATMANI                             │
│   (lib/data/* — Hive, JSON, Models/DTOs, Repositories)      │
└─────────────────────────────────────────────────────────────┘
```

#### A. Domain Katmanı (`lib/domain/`) — Uygulamanın Kalbi
- **En Saf Katmandır:** Bu katmanda tek bir satır dahi Flutter kodu (`material.dart`), UI kütüphanesi veya Hive/veritabanı kodu **BULUNMAZ**. Tamamen saf Dart nesneleridir.
- **Entities (Varlıklar):** İş mantığının değişmez kurallarıdır (`Dog`, `Booking`, `SitterListing`, `UserRole`, `ChatMessage`).
- **Repository Interfaces (Sözleşmeler):** Verinin nereden geleceğini bilmez, sadece "bana şu veriyi getirecek bir fonksiyon olmalı" diyen soyut (`abstract`) arayüzlerdir.
- **Use Cases (Kullanım Senaryoları):** Uygulamanın yapabildiği tekil eylemlerdir (`AddVaccinationUseCase`, `SearchSittersUseCase`, `CreateBookingUseCase`).

#### B. Data Katmanı (`lib/data/`) — Veriyi Getiren ve Saklayan Katman
- Domain katmanının tanımladığı sözleşmeleri gerçek dünyaya bağlar.
- **Models / DTOs:** Domain varlıklarını genişletir ve Hive kutularına yazılabilmesi için `@HiveType`, `@HiveField` anotasyonları ile `fromJson`/`toJson` dönüşümlerini üstlenir.
- **Repositories (Somut Sınıflar):** `BookingRepository`, `DogRepository`, `SitterRepository` gibi sınıflar veriyi diskten (Hive), yerel JSON dosyasından (`assets/data/sitters.json`) veya ileride REST API'den okur.

#### C. Presentation Katmanı (`lib/features/`, `lib/app/`) — Kullanıcının Gördüğü Yüz
- Ekranlar (`View`), yeniden kullanılabilir görsel parçalar (`Widgets`) ve ekran durum yöneticileri (`Cubit`).
- Presentation katmanı asla doğrudan veritabanına veya JSON dosyalarına erişmez; yalnızca Domain katmanındaki **UseCase** sınıflarını tetikler.

---

## 2. SOLID Prensipleri ve Projedeki Somut Kanıtları

PawCare projesi, nesne yönelimli programlamanın altın kuralları olan **SOLID** prensiplerini eksiksiz uygular. Mülakatlarda "Projende SOLID uyguladın mı?" sorusuna vereceğiniz somut örnekler:

### 1. Single Responsibility Principle (Tek Sorumluluk Prensibi - SRP)
> *Bir sınıfın değişmesi için yalnızca tek bir nedeni olmalıdır.*

- **Somut Örnek (Use Cases):**  
  `lib/domain/usecases/pet/add_vaccination_use_case.dart` sınıfına bakın. Bu sınıf sadece ve sadece bir köpeğe aşı eklemekten sorumludur. Profil güncelleme, fotoğraf değiştirme veya kilo kaydetme işleri bu sınıfta yer almaz.
- **Somut Örnek (Model vs Entity Ayrımı):**  
  `lib/domain/entities/dog.dart` saf iş kurallarını tutarken, `lib/data/models/models.dart` içerisindeki `DogModel` sadece verinin Hive formatına dönüştürülmesinden sorumludur.

### 2. Open/Closed Principle (Açık/Kapalı Prensibi - OCP)
> *Yazılım varlıkları genişletilmeye açık, ancak değiştirilmeye kapalı olmalıdır.*

- **Somut Örnek (Repository Mimarisi):**  
  Yarın PawCare'e bir Firebase veya REST API backend'i bağlamak istediğimizde; mevcut `BookingRepositoryInterface` sözleşmesine ve `GetBookingsUseCase` sınıfına dokunmak zorunda kalmayız. Sadece yeni bir `FirebaseBookingRepository implements BookingRepositoryInterface` sınıfı yazarız ve sisteme takarız. Mevcut çalışan kod bozulmaz, sistem genişletilmiş olur.

### 3. Liskov Substitution Principle (Liskov'un Yerine Geçme Prensibi - LSP)
> *Türetilen sınıflar, türedikleri temel sınıfların/arayüzlerin yerine sorunsuzca kullanılabilmelidir.*

- **Somut Örnek (Unit Testlerdeki Fake Repolar):**  
  `test/repositories_test.dart` ve `test/bookings_test.dart` dosyalarında, gerçek `BookingRepository` yerine bellek içi çalışan `FakeBookingRepository` sınıfını oluşturduk. Her ikisi de `BookingRepositoryInterface` sözleşmesini uyguladığı için, UseCase ve Cubit'ler aradaki farkı anlamadan hatasız çalışmaya devam eder.

### 4. Interface Segregation Principle (Arayüz Ayrımı Prensibi - ISP)
> *İstemciler kullanmadıkları metodları içeren şişkin arayüzlere bağımlı olmaya zorlanmamalıdır.*

- **Somut Örnek:**  
  Tüm veri işlemlerini tek bir devasa `AppRepositoryInterface` içine yığmadık (`getSitters`, `addVaccine`, `createBooking`, `markNotificationRead` gibi 20 metodu tek arayüzde toplamak büyük bir ISP ihlali olurdu).  
  Bunun yerine 5 odaklı ve bağımsız arayüz tasarladık:
  - `SitterRepositoryInterface`
  - `BookingRepositoryInterface`
  - `DogRepositoryInterface`
  - `NotificationRepositoryInterface`
  - `SettingsRepositoryInterface`  
  Örneğin aşı ekleyen UseCase, sadece `DogRepositoryInterface`'i görür; bakıcı veya rezervasyon metodlarıyla muhatap olmaz.

### 5. Dependency Inversion Principle (Bağımlılıkların Tersine Çevrilmesi - DIP)
> *Yüksek seviyeli modüller, düşük seviyeli modüllere bağımlı olmamalıdır. Her ikisi de soyutlamalara (arayüzlere) bağımlı olmalıdır.*

- **Somut Örnek (Kritik Bağımlılık Yönü):**  
  `lib/domain/usecases/booking/get_bookings_use_case.dart` sınıfı, `data` katmanındaki somut `BookingRepository` sınıfına bağımlı **DEĞİLDİR**.  
  Yalnızca `BookingRepositoryInterface` arayüzüne bağımlıdır. Somut sınıf olan `BookingRepository` ise bu arayüzü uygular (`implements`). Yani bağımlılıklar soyutlamaya doğrudur; yüksek seviye çekirdek, alt seviye depolama detayına boyun eğmez.

---

## 3. Klasör Düzeni, Mimarisi ve Bağımlılık Haritası

### 3.1. Klasör Anatomisi
```text
lib/
├── main.dart                       # Uygulamanın giriş noktası (Hive başlatma, bağımlılık kurulumu)
├── app/                            # Uygulama omurgası
│   ├── app.dart                    # PawCareApp kök widget'ı (MultiBlocProvider, Tema bağlantısı)
│   └── router/                     # GoRouter yapılandırması
│       ├── app_router.dart         # Sayfa yolları, geçiş animasyonları, yönlendirme (redirect)
│       ├── route_names.dart        # Sabit rota string'leri (RoutePaths ve RouteNames)
│       └── app_shell.dart          # ShellRoute: Alt Bar (BottomNav) ve Üst Bar'ı (Header) tutan iskelet
├── core/                           # Proje geneli ortak modüller
│   ├── constants/                  # app_constants.dart (Sistem sabitleri)
│   ├── theme/                      # Tasarım sistemi token'ları
│   │   ├── app_colors.dart         # Renk paletleri (Primary, Accent, Sage, Slate vb.)
│   │   ├── app_typography.dart     # GoogleFonts tipografi stilleri (Outfit, Inter)
│   │   ├── app_theme.dart          # Material 3 light/dark ThemeData tanımları
│   │   └── theme_cubit.dart        # Dinamik açık/koyu tema durum yöneticisi
│   ├── utils/                      # Yardımcı araçlar ve uygulama durumu
│   │   ├── app_state.dart          # In-memory oturum, çift yönlü rol senkronizasyonu ve bildirim bus'ı
│   │   └── image_storage_service.dart # Yerel fotoğraf kaydetme yardımcısı
│   └── widgets/                    # Ortak UI bileşenleri
│       ├── paw_bottom_nav.dart     # Rol bazlı dinamik değişen alt navigasyon çubuğu
│       ├── paw_header_actions.dart # Bildirim butonu, arama ve profil başlık aksiyonları
│       └── modals/                 # Proje genelinde açılan modal pencereler
│           ├── chat_modal.dart         # İki yönlü canlı mesajlaşma penceresi
│           ├── live_tracking_modal.dart# CustomPainter ile çizilen canlı GPS takip modalı
│           ├── call_modal.dart         # Bakıcıyı arama simülasyon modalı
│           └── modals.dart             # Barrel export dosyası
├── domain/                         # Saf İş Mantığı (İç Çekirdek - Pure Dart)
│   ├── domain.dart                 # Barrel export
│   ├── entities/                   # İş varlıkları (Dog, Booking, Sitter, UserRole vb.)
│   ├── repositories/               # Repository sözleşmeleri/arayüzleri (*Interface.dart)
│   └── usecases/                   # Tekil iş senaryoları (sitter, booking, pet, notification, settings)
├── data/                           # Veri Katmanı (Dış Çekirdek)
│   ├── local/                      # hive_boxes.dart (Hive kutu tanımları ve TypeAdapter başlatma)
│   ├── models/                     # models.dart (Hive uyumlu DTO sınıfları ve serileştirme)
│   └── repositories/               # Domain sözleşmelerini uygulayan somut sınıflar
└── features/                       # 10 Bağımsız Ekran Modülü (Feature-First Presentation)
    ├── splash/                     # Açılış ekranı ve animasyonu
    ├── onboarding/                 # Tanıtım ekranı (WelcomeScreen, PageView)
    ├── auth/                       # Giriş ve kayıt modalları (LoginModal, SignupModal, AuthCubit)
    ├── home/                       # Evcil hayvan sahibi ana sayfası (OwnerHomeScreen)
    ├── discovery/                  # Bakıcı arama, filtreleme ve detay (ExploreScreen, SitterDetailScreen)
    ├── bookings/                   # Rezervasyon talepleri ve durum kartları (OwnerBookingsScreen)
    ├── pets/                       # Köpek profili ve aşı takip karnesi (DogProfileScreen, HealthCardModal)
    ├── provider/                   # Hizmet veren / bakıcı kontrol paneli (SitterDashboardScreen)
    ├── notifications/              # Bildirim merkezi alt sayfası (NotificationsSheet)
    └── profile/                    # Kullanıcı profil ayarları ve rol değiştirme ekranı
```

---

## 4. Projede Kullanılan Flutter ve Dart Yetenekleri

PawCare, Flutter'ın ve modern mobil uygulama ekosisteminin en güçlü bileşenlerini bünyesinde barındırır:

### 1. Durum Yönetimi (State Management) — Çift Katmanlı Strateji
- **`flutter_bloc` (`Cubit`):**  
  Tek yönlü veri akışını (Unidirectional Data Flow) sağlamak için kullanılır. Ekran seviyesindeki durumlar `emit(YeniDurum)` yöntemiyle yönetilir:
  - `ThemeCubit`: Uygulamanın aydınlık/karanlık/sistem temasını yönetir.
  - `RoleCubit`: Kullanıcının evcil hayvan sahibi (`owner`) mi yoksa bakıcı (`sitter`) mı olduğunu tutar.
  - `BookingsCubit`: Talepleri yükler, filtreler ve yeni rezervasyon durumunu yayar.
  - `SplashCubit`: Karşılama ekranının daha önce görülüp görülmediğini kontrol eder.
- **`ChangeNotifier` (`AppState`):**  
  Uygulamanın hafızadaki reaktif omurgasıdır. Henüz bir uzaktaki backend olmadığı için, iki rol arasındaki anlık mesajlaşmayı, rol değişiminde alt menü indekslerinin korunmasını ve anlık bildirim tetiklemelerini üstlenen hafif bir Event-Bus gibi çalışır.

### 2. İleri Seviye Navigasyon (`go_router`)
- **Declarative (Bildirimli) Yönlendirme:** Geleneksel `Navigator.push` yerine URL tabanlı, okunabilir ve derin bağlantıya (Deep Linking) uygun rota yapısı.
- **`ShellRoute` Mimarisi:**  
  `app_shell.dart` içerisinde bir `ShellRoute` tanımlanmıştır. Bu sayede ekranlar arasında geçiş yapılırken alt menü (`PawBottomNav`) ve üst başlık aksiyonları (`PawHeaderActions`) ekrandan yok olmaz; sadece içerikteki gövde (`child`) pürüzsüzce değişir.
- **`redirect` Koruması:** Kullanıcı uygulamayı ilk kez açtığında karşılama ekranına (`/welcome`), daha önce açtıysa doğrudan ana sayfaya (`/home`) yönlendirilir.

### 3. Çevrimdışı Veri Depolama (`hive` & `hive_flutter`)
- **Hafif ve Hızlı NoSQL:** SQLite'ın karmaşık SQL tabloları yerine Dart nesnelerini doğrudan binary formatta diske kaydeden yüksek performanslı veritabanı.
- **TypeAdapter Deseni:** `DogModel`, `BookingModel`, `NotificationModel` gibi sınıflar Hive adaptörleri ile serileştirilir. İnternet bağlantısı olmasa bile uygulama kapatılıp açıldığında tüm veriler saklanır.

### 4. İleri Seviye Çizim ve Özel Grafikler (`CustomPainter` & `Canvas`)
- **Canlı GPS Rotası Simülasyonu:**  
  `lib/core/widgets/modals/live_tracking_modal.dart` içerisinde `_RoutePainter extends CustomPainter` sınıfı yazılmıştır.
- **Ne Yapar?** Canvas API'si kullanarak ekrana Caddebostan sahilindeki yürüyüş yolunu çizer; başlangıç noktasına yeşil nokta, anlık konuma animasyonlu mavi pati ikonu, katedilen mesafeye ise yumuşak renk geçişli (gradient) kesikli çizgiler uygular.

### 5. Modern Görsel Efektler: Glassmorphism (`BackdropFilter`)
- Tüm modal pencerelerde (`chat_modal.dart`, `live_tracking_modal.dart`, `login_modal.dart`, `health_card_modal.dart`) `BackdropFilter` ve `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` kullanılmıştır.
- Arka plandaki içeriğe buzlu cam (frosted glass) efekti verilerek modern ve birinci sınıf (premium) bir mobil kullanıcı deneyimi sağlanmıştır.

### 6. Zengin Kütüphane Desteği
- **`table_calendar`:** Aşı takip karnesinde ve rezervasyon oluşturma ekranında interaktif takvim görünümü.
- **`intl`:** Para birimi (`₺`), tarih formatlama (`d MMMM y`, `HH:mm`) ve yerelleştirme desteği.
- **`google_fonts`:** Projenin görsel kimliğine uygun `Outfit` ve `Inter` modern font entegrasyonu.
- **`image_picker`:** Kullanıcının telefon galerisinden köpeğinin gerçek fotoğrafını seçip profiline eklemesi.
- **`PageView`:** Onboarding karşılama ekranında pürüzsüz yatay kaydırma kartları ve sayfa gösterge noktaları.

---

## 5. Uçtan Uca İş Akışları (Hangi Klasörde Ne Oluyor?)

### Akış 1: Uygulama Başlatma ve Karşılama (`splash` ➔ `onboarding` ➔ `auth`)
1. `main.dart` çalışır, Hive kutularını açar (`HiveBoxes.openBoxes()`).
2. `AppRouter` başlangıç rotasını `/splash` olarak açar.
3. `SplashPage`, `SplashCubit` aracılığıyla `SettingsRepository`'ye sorar: "Kullanıcı daha önce giriş yaptı mı / onboarding gördü mü?".
4. Kullanıcı ilk kez geliyorsa `/welcome` sayfasına yönlendirilir (`welcome_screen.dart`). Burada 3 adımlı `PageView` tanıtım kartları gösterilir.
5. "Giriş Yap" butonuna basıldığında `showModalBottomSheet` ile `login_modal.dart` buzlu cam efektiyle açılır.

### Akış 2: Çift Rol (Dual-Role) ve Dinamik Arayüz Değişimi
- PawCare'de iki farklı kullanıcı rolü vardır: **Köpek Sahibi (`UserRole.owner`)** ve **Hizmet Veren Bakıcı (`UserRole.sitter`)**.
- Kullanıcı profil sayfasından (`ProfileScreen`) veya başlık barındaki rol butonundan rolünü değiştirdiğinde:
  1. `AppState.setRole(...)` ve `RoleCubit.setRole(...)` tetiklenir.
  2. `PawBottomNav` anında rolün menüsüne adapte olur:
     - Sahip Modu: *Keşfet*, *Rezervasyonlar*, *Köpeğim*, *Profilim*.
     - Bakıcı Modu: *Gelen Talepler*, *Kazançlarım*, *Takvimim*, *Profilim*.
  3. Ana ekran `SitterDashboardScreen` görünümüne geçer.

### Akış 3: Bakıcı Keşfi ve Detay İnceleme (`discovery`)
1. Kullanıcı `ExploreScreen` üzerindedir. Üstteki kategori çiplerinden (Köpek Oteli, Yürüyüş, Evde Bakım) birine tıklar.
2. `GetSittersUseCase` ve `SearchSittersUseCase` çalışır, filtreye uyan bakıcı kartlarını listeler.
3. Bir bakıcıya tıklandığında `context.push(RoutePaths.sitterDetail, extra: sitter)` ile `sitter_detail_screen.dart` açılır.
4. Burada bakıcının fotoğraf galerisi, biyografisi, günlük ücreti, kullanıcı yorumları ve sağ alttaki "Rezervasyon Yap" aksiyon çubuğu yer alır.

### Akış 4: Rezervasyon Oluşturma ve Talep Yönetimi (`bookings`)
1. Bakıcı detayından "Rezervasyon Yap" dendiğinde tarih ve saat seçilir.
2. `CreateBookingUseCase` çağrılır, yeni rezervasyon `HiveBoxes.bookings` kutusuna ve `AppState` listesine eklenir.
3. Kullanıcı "Taleplerim" sekmesine geçtiğinde `OwnerBookingsScreen` açılır; `BookingCard` üzerinde talep durumu renkli çiplerle görünür:
   - 🟡 **Beklemede:** Bakıcının onayı bekleniyor.
   - 🟢 **Onaylandı:** Bakıcı kabul etti, ödeme tamamlandı.
   - 🔵 **Tamamlandı:** Hizmet başarıyla bitti.

### Akış 5: Canlı Yürüyüş Takibi ve Otel Kartı (`live_tracking_modal.dart`)
1. Onaylanmış bir rezervasyon kartındaki "Canlı Takip" butonuna tıklandığında tam ekran bir alt pencere açılır.
2. Eğer hizmet bir yürüyüş hizmeti ise: `_RoutePainter` haritada anlık konumu simüle eder; atılan adım, yakılan kalori ve yürüyüş süresi sayaçla gösterilir.
3. Eğer hizmet bir **Köpek Oteli** hizmeti ise: Canlı yürüyüş yerine otelin konum kartı ("Mutlu Patiler Köpek Oteli - Caddebostan") ve otele doğrudan telefon açma / mesaj atma butonları gösterilir.

### Akış 6: Köpek Sağlık Karnesi ve Aşı Takvimi (`pets`)
1. `DogProfileScreen` sayfası açıldığında `GetDogProfileUseCase` köpeğin bilgilerini (Barley, 2 yaşında Golden Retriever) yükler.
2. "Aşı Takvimi" sekmesine geçildiğinde `HealthCardModal` açılır.
3. `AddVaccinationUseCase` sayesinde kullanıcı yeni yapılan bir karma veya kuduz aşısını veteriner ismi ve tarihiyle kaydedebilir.

### Akış 7: İki Yönlü Reaktif Mesajlaşma (`chat_modal.dart`)
- Backend olmadan iki kişinin sohbeti nasıl simüle edildi?
  1. Mesajlar bakıcı bazlı oda haritasında saklanır (`Map<String, List<ChatMessage>>`).
  2. Kullanıcı **Bakıcı (Ayşe Yılmaz)** modundayken bir mesaj yazdığında, gönderen "Ayşe Yılmaz", hedef "Aygen Yıldırım" olur.
  3. Kullanıcı **Köpek Sahibi** moduna geçtiğinde, sohbet balonunun yönü (`isMe`) otomatik tersine döner; Ayşe'nin mesajı sol tarafta gelen kutusu olarak belirir.
  4. Aynı anda `AppState.addNotification(...)` çalışarak bildirim merkezine "Ayşe Yılmaz'dan yeni mesaj 💬" bildirimi otomatik düşer.

---

