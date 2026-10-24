import '../entities/notification.dart';

/// Bildirim verilerine erişim ve okundu işlemlerini tanımlayan soyut Domain sözleşmesi.
abstract class NotificationRepositoryInterface {
  /// En güncel ve okunmamışlar öncelikli olacak şekilde bildirimleri getirir.
  List<NotificationItem> getNotifications();

  /// Okunmamış bildirim adedini döner.
  int getUnreadCount();

  /// Yeni bildirim ekler.
  Future<void> addNotification(NotificationItem notification);

  /// Belirtilen bildirimi okundu olarak işaretler.
  Future<void> markAsRead(String id);

  /// Tüm bildirimleri okundu olarak işaretler.
  Future<void> markAllAsRead();

  /// Bildirim listesini temizler.
  Future<void> clearAll();
}
