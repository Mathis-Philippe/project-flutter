import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'chat_conversation_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: ListView.separated(
        itemCount: mockChats.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(
              chat.senderName,
              style: TextStyle(
                fontWeight: chat.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: chat.isRead ? Colors.grey : Colors.black87,
                fontWeight: chat.isRead ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                if (!chat.isRead)
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
              ],
            ),
            onTap: () {
              // Navigation vers l'écran de la conversation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatConversationScreen(chat: chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}