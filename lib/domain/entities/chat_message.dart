import 'user_role.dart';

/// Bakıcı ve köpek sahibi arasındaki mesajlaşma kaydını temsil eden saf iş alanı varlığı (Entity).
class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final String time;
  final bool isMe;
  final UserRole? senderRole;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
    this.senderRole,
  });

  ChatMessage copyWith({
    String? id,
    String? senderName,
    String? text,
    String? time,
    bool? isMe,
    UserRole? senderRole,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      senderRole: senderRole ?? this.senderRole,
    );
  }
}
