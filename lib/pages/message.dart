import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const MessagesScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    chatRoomId = _generateChatRoomId(currentUserId, widget.receiverId);
  }

  /// 🔹 Generate a consistent Chat Room ID (ensures same ID for both users)
  String _generateChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return "${sortedIds[0]}_${sortedIds[1]}";
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).collection('messages').add({
        'senderId': currentUserId,
        'receiverId': widget.receiverId,
        'text': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Message sent successfully!");
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: const Color(0xFF1471D3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child:StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('chats')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No messages yet"));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom()); // Ensure scrolling

    return ListView(
      controller: _scrollController,
      children: snapshot.data!.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        bool isSender = data['senderId'] == currentUserId;
        String time = data['timestamp'] != null
            ? DateFormat.jm().format((data['timestamp'] as Timestamp).toDate())
            : "Sending...";

        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  data['text'] ?? "",
                  style: TextStyle(color: isSender ? Colors.white : Colors.black),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: isSender ? Colors.white70 : Colors.black54),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  },
)

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
