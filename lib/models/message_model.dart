class ChatMessage {
  final String id;
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isRead;
  final int unreadCount;
  final bool isOnline;

  ChatMessage({
    required this.id,
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

List<ChatMessage> mockChats = [
  ChatMessage(
    id: 'mock1',
    senderName: "Sigma Ohio",
    lastMessage: "aura debt 💀 session mewing a cahtelet?",
    time: "il y a 7 minutes",
    avatarUrl: "assets/images/99hnur.jpg",
    isRead: false,
    unreadCount: 1,
    isOnline: true,
  ),
  ChatMessage(
    id: 'mock2',
    senderName: "Edging King",
    lastMessage: "skibidi dub dub dub yes yes",
    time: "il y a environ 2 heures",
    avatarUrl: "assets/images/QuandaleDingle.webp",
    isRead: true,
    unreadCount: 0,
    isOnline: false,
  ),
  ChatMessage(
    id: 'mock3',
    senderName: "Aura Farmer",
    lastMessage: "no cap !",
    time: "il y a 30 minutes",
    avatarUrl: "assets/images/Brr_Brr_patatree.png",
    isRead: false,
    unreadCount: 2,
    isOnline: true,
  ),
  ChatMessage(
    id: 'mock4',
    senderName: "Kanye East",
    lastMessage: "+ 100 aura pour toi bro",
    time: "il y a 1 jour",
    avatarUrl: "assets/images/oar2.jpg",
    isRead: true,
    unreadCount: 0,
    isOnline: false,
  ),
  ChatMessage(
    id: 'mock5',
    senderName: "Skibidi Gemini",
    lastMessage: "Vends pieds 😊",
    time: "il y a 12 minutes",
    avatarUrl: "assets/images/Snooffi_Zeffirulli.webp",
    isRead: false,
    unreadCount: 1,
    isOnline: true,
  ),
];

List<Contact> myContacts = [
  Contact(id: 'mock1', name: "Sigma Ohio", avatarUrl: "https://i.pravatar.cc/150?img=1", isOnline: true, isContact: true),
  Contact(id: 'mock2', name: "Edging King", avatarUrl: "https://i.pravatar.cc/150?img=3", isOnline: false, isContact: true),
  Contact(id: 'mock3', name: "Aura Farmer", avatarUrl: "https://i.pravatar.cc/150?img=4", isOnline: true, isContact: true),
  Contact(id: 'mock4', name: "Kanye East", avatarUrl: "https://i.pravatar.cc/150?img=8", isOnline: false, isContact: true),
  Contact(id: 'mock5', name: "Skibidi Gemini", avatarUrl: "https://i.pravatar.cc/150?img=9", isOnline: true, isContact: true),
];

List<Contact> suggestions = [
  Contact(id: 'mock11', name: "Nicolas Sarkozy", avatarUrl: "https://i.pravatar.cc/150?img=11", isOnline: false, isContact: false),
  Contact(id: 'mock12', name: "Panard Licker", avatarUrl: "https://i.pravatar.cc/150?img=12", isOnline: true, isContact: false),
  Contact(id: 'mock14', name: "Hugo Decrypte", avatarUrl: "https://i.pravatar.cc/150?img=14", isOnline: false, isContact: false),
  Contact(id: 'mock15', name: "Jules Branleroux", avatarUrl: "https://i.pravatar.cc/150?img=15", isOnline: true, isContact: false),
];