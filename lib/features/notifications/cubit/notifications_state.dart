import '../../../domain/entities/notification.dart';

/// Bildirim durum aşamaları.
enum NotificationsStatus { initial, loading, loaded, error }

/// Bildirim filtreleme seçenekleri.
enum NotificationFilter { all, unread, booking, vaccine }

/// Bildirimler ekranı ve modalı durum sınıfı.
class NotificationsState {
  final NotificationsStatus status;
  final List<NotificationItem> allNotifications;
  final List<NotificationItem> filteredNotifications;
  final NotificationFilter activeFilter;
  final int unreadCount;
  final String? errorMessage;
  final String? markingId;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.allNotifications = const [],
    this.filteredNotifications = const [],
    this.activeFilter = NotificationFilter.all,
    this.unreadCount = 0,
    this.errorMessage,
    this.markingId,
  });

  bool get isLoading => status == NotificationsStatus.loading;
  bool get isLoaded => status == NotificationsStatus.loaded;
  bool get isError => status == NotificationsStatus.error;
  bool get hasUnread => unreadCount > 0;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? allNotifications,
    List<NotificationItem>? filteredNotifications,
    NotificationFilter? activeFilter,
    int? unreadCount,
    String? errorMessage,
    String? markingId,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      allNotifications: allNotifications ?? this.allNotifications,
      filteredNotifications:
          filteredNotifications ?? this.filteredNotifications,
      activeFilter: activeFilter ?? this.activeFilter,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage,
      markingId: markingId,
    );
  }
}
