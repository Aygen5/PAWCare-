import '../local/hive_boxes.dart';
import '../models/models.dart';

class NotificationRepository {
  /// Okunmamış ve en yeni bildirimler üstte olacak şekilde tüm bildirimleri getirir.
  List<NotificationItem> getNotifications() {
    final list = HiveBoxes.notifications.values.toList();
    list.sort((a, b) {
      if (a.isRead != b.isRead) {
        return a.isRead ? 1 : -1;
      }
      return b.timestamp.compareTo(a.timestamp);
    });
    return list;
  }

  /// Okunmamış bildirim sayısını döner.
  int getUnreadCount() {
    return HiveBoxes.notifications.values.where((n) => !n.isRead).length;
  }

  /// Yeni bir bildirim ekler.
  Future<void> addNotification(NotificationItem notification) async {
    await HiveBoxes.notifications.put(notification.id, notification);
  }

  /// Belirtilen bildirimi okundu olarak işaretler.
  Future<void> markAsRead(String id) async {
    final notif = HiveBoxes.notifications.get(id);
    if (notif != null && !notif.isRead) {
      final updated = notif.copyWith(isRead: true);
      await HiveBoxes.notifications.put(id, updated);
    }
  }

  /// Tüm bildirimleri okundu olarak işaretler.
  Future<void> markAllAsRead() async {
    for (final notif in HiveBoxes.notifications.values) {
      if (!notif.isRead) {
        final updated = notif.copyWith(isRead: true);
        await HiveBoxes.notifications.put(notif.id, updated);
      }
    }
  }

  /// Tüm bildirimleri siler.
  Future<void> clearAll() async {
    await HiveBoxes.notifications.clear();
  }
}
