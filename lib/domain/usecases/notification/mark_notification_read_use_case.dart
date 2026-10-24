import '../../repositories/notification_repository_interface.dart';

/// Bildirimi okundu olarak işaretleyen veya tüm bildirimleri okundu yapan kullanım senaryosu.
class MarkNotificationReadUseCase {
  final NotificationRepositoryInterface repository;

  const MarkNotificationReadUseCase(this.repository);

  Future<void> markSingleAsRead(String id) {
    return repository.markAsRead(id);
  }

  Future<void> markAllAsRead() {
    return repository.markAllAsRead();
  }

  Future<void> clearAll() {
    return repository.clearAll();
  }
}
