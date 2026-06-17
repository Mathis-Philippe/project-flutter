class ChatMessage {
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isRead;
  final int unreadCount;
  final bool isOnline;

  ChatMessage({
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.isRead = true,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class Contact {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final bool isContact;

  Contact({
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.isContact = false,
  });
}

List<ChatMessage> mockChats = [
  ChatMessage(
    senderName: "Sigma Ohio",
    lastMessage: "aura debt 💀 session mewing a cahtelet?",
    time: "il y a 7 minutes",
    avatarUrl: "https://i.pravatar.cc/150?img=1",
    isRead: false,
    unreadCount: 1,
    isOnline: true,
  ),
  ChatMessage(
    senderName: "Edging King",
    lastMessage: "skibidi dub dub dub yes yes",
    time: "il y a environ 2 heures",
    avatarUrl: "https://i.pravatar.cc/150?img=3",
    isRead: true,
    unreadCount: 0,
    isOnline: false,
  ),
  ChatMessage(
    senderName: "Aura Farmer",
    lastMessage: "no cap !",
    time: "il y a 30 minutes",
    avatarUrl: "https://i.pravatar.cc/150?img=4",
    isRead: false,
    unreadCount: 2,
    isOnline: true,
  ),
  ChatMessage(
    senderName: "Kanye East",
    lastMessage: "+ 100 aura pour toi bro",
    time: "il y a 1 jour",
    avatarUrl: "https://i.pravatar.cc/150?img=8",
    isRead: true,
    unreadCount: 0,
    isOnline: false,
  ),
  ChatMessage(
    senderName: "Skibidi Gemini",
    lastMessage: "Vends pieds 😊",
    time: "il y a 12 minutes",
    avatarUrl: "https://i.pravatar.cc/150?img=9",
    isRead: false,
    unreadCount: 1,
    isOnline: true,
  ),
];

List<Contact> myContacts = [
  Contact(name: "Sigma Ohio", avatarUrl: "https://i.pravatar.cc/150?img=1", isOnline: true, isContact: true),
  Contact(name: "Edging King", avatarUrl: "https://i.pravatar.cc/150?img=3", isOnline: false, isContact: true),
  Contact(name: "Aura Farmer", avatarUrl: "https://i.pravatar.cc/150?img=4", isOnline: true, isContact: true),
  Contact(name: "Kanye East", avatarUrl: "https://i.pravatar.cc/150?img=8", isOnline: false, isContact: true),
  Contact(name: "Skibidi Gemini", avatarUrl: "https://i.pravatar.cc/150?img=9", isOnline: true, isContact: true),
];

List<Contact> suggestions = [
  Contact(name: "Nicolas Sarkozy", avatarUrl: "https://i.pravatar.cc/150?img=11", isOnline: false, isContact: false),
  Contact(name: "Panard Licker", avatarUrl: "https://i.pravatar.cc/150?img=12", isOnline: true, isContact: false),
  Contact(name: "Hugo Decrypte", avatarUrl: "https://i.pravatar.cc/150?img=14", isOnline: false, isContact: false),
  Contact(name: "Jules Branleroux", avatarUrl: "https://i.pravatar.cc/150?img=15", isOnline: true, isContact: false),
];