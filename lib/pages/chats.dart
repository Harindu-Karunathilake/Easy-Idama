import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad/pages/message.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF1471D3),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text("Chats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users available"));
          }

          var users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return FutureBuilder<String>(
                future: _getLatestMessage(currentUserId, user.id),
                builder: (context, messageSnapshot) {
                  return ChatCard(
                    name: user['name'],
                    userId: user.id,
                    lastMessage: messageSnapshot.data ?? "", // Display latest message
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesScreen(receiverId: user.id, receiverName: user['name']),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _getLatestMessage(String currentUserId, String otherUserId) async {
    try {
      String chatRoomId = _generateChatRoomId(currentUserId, otherUserId);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['text'];
      } else {
        return "";
      }
    } catch (e) {
      print("Error fetching latest message: $e");
      return "";
    }
  }

  String _generateChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return "${sortedIds[0]}_${sortedIds[1]}";
  }
}

class ChatCard extends StatelessWidget {
  final String name;
  final String userId;
  final String lastMessage; // Added lastMessage
  final VoidCallback press;

  const ChatCard({
    super.key,
    required this.name,
    required this.userId,
    required this.lastMessage, // Added lastMessage
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/profile.jpg'), // Dummy profile image
            ),
            const SizedBox(width: 12),
            Expanded( // Use Expanded to allow text wrapping
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    lastMessage, // Display last message
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1, // Limit to one line
                    overflow: TextOverflow.ellipsis, // Add ellipsis if too long
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