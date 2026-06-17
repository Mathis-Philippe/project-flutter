class ChatMessage {
  final String id;
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isRead;
  final int unreadCount;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.isRead = true,
    this.unreadCount = 0,
  });
}

class Contact {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final bool isContact;

  Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.isContact = false,
  });
}
