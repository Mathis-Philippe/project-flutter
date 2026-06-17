class ChatMessage {
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isRead;

  ChatMessage({
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.isRead,
  });
}

List<ChatMessage> mockChats = [
  ChatMessage(
    senderName: "Alice Martin",
    lastMessage: "Salut ! On se voit toujours à 14h ?",
    time: "10:30",
    avatarUrl: "https://i.pravatar.cc/150?img=1",
    isRead: false,
  ),
  ChatMessage(
    senderName: "Thomas Dubois",
    lastMessage: "Le commit est poussé sur GitHub.",
    time: "Hier",
    avatarUrl: "https://i.pravatar.cc/150?img=2",
    isRead: true,
  ),
  ChatMessage(
    senderName: "Sophie Bernard",
    lastMessage: "Merci beaucoup pour ton aide !",
    time: "Lun.",
    avatarUrl: "https://i.pravatar.cc/150?img=5",
    isRead: true,
  ),
];