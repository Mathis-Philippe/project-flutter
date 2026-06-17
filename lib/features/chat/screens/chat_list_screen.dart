import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import 'chat_conversation_screen.dart';
import '../../contacts/screens/gyatt_list_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatMessage> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;

      final friendsRes = await supabase.from('friends').select('friend_id').eq('user_id', userId);
      final friendIds = (friendsRes as List).map((e) => e['friend_id'] as String).toList();

      if (friendIds.isEmpty) {
        if (mounted) setState(() { _chats = []; _isLoading = false; });
        return;
      }

      final profilesRes = await supabase.from('profiles').select().inFilter('id', friendIds);
      final Map<String, dynamic> profiles = { for (var p in (profilesRes as List)) p['id'] : p };

      List<ChatMessage> loadedChats = [];
      for (String fId in friendIds) {
        final profile = profiles[fId] ?? {};
        final name = profile['username'] ?? 'Ami';
        final avatar = profile['avatar_url'] ?? 'https://i.pravatar.cc/150?u=$fId';

        final messagesRes = await supabase
            .from('messages')
            .select()
            .or('and(sender_id.eq.$userId,receiver_id.eq.$fId),and(sender_id.eq.$fId,receiver_id.eq.$userId)')
            .order('id', ascending: false)
            .limit(1);

        String lastMsg = 'Nouvelle conversation';
        String timeStr = '';

        if ((messagesRes as List).isNotEmpty) {
          final msg = messagesRes.first;
          lastMsg = msg['text'] ?? 'Message';
          final dt = DateTime.parse(msg['created_at']).toLocal();
          timeStr = '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
        }

        loadedChats.add(ChatMessage(
          id: fId,
          senderName: name,
          lastMessage: lastMsg,
          time: timeStr,
          avatarUrl: avatar,
          isRead: true,
          unreadCount: 0,
        ));
      }

      if (mounted) {
        setState(() {
          _chats = loadedChats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur chargement chats: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur chats: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header avec dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFF4CAF50), Color(0xFF00BCD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'W Dans le Chat',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        _headerIconButton(
                          Icons.person_add_rounded,
                          () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const GyattListScreen()),
                            );
                            _loadChats(); // Recharge les chats au retour
                          },
                        ),
                        const SizedBox(width: 4),
                        _headerIconButton(Icons.person_rounded, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Liste des chats
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _chats.isEmpty 
                ? const Center(child: Text("Aucune conversation. Ajoute des amis !"))
                : RefreshIndicator(
                    onRefresh: _loadChats,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        return _buildChatTile(context, chat);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 26),
      onPressed: onTap,
      splashRadius: 22,
    );
  }

  Widget _buildChatTile(BuildContext context, ChatMessage chat) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatConversationScreen(chat: chat)),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chat.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 14),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.senderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}