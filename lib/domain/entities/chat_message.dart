/// Bakıcı ve köpek sahibi arasındaki mesajlaşma kaydını temsil eden saf iş alanı varlığı (Entity).
class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final String time;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
  });

  ChatMessage copyWith({
    String? id,
    String? senderName,
    String? text,
    String? time,
    bool? isMe,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
    );
  }
}
