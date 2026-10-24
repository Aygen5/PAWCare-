import '../../entities/notification.dart';
import '../../repositories/notification_repository_interface.dart';

/// Bildirimleri ve okunmamış bildirim adedini getiren kullanım senaryosu.
class GetNotificationsUseCase {
  final NotificationRepositoryInterface repository;

  const GetNotificationsUseCase(this.repository);

  List<NotificationItem> call() {
    return repository.getNotifications();
  }

  int getUnreadCount() {
    return repository.getUnreadCount();
  }
}
