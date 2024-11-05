import 'package:carpool/features/home/data/message_model.dart';
import 'package:carpool/features/home/presentation/widgets/ChatBubble/chatBubble.dart';
import 'package:carpool/features/home/presentation/widgets/ChatBubble/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String user1Id;
  final String driver1Id;

  const ChatScreen({
    required this.user1Id,
    required this.driver1Id,
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await sendMessage(
          widget.user1Id, widget.driver1Id, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatId = widget.user1Id.compareTo(widget.driver1Id) < 0
        ? '${widget.user1Id}_${widget.driver1Id}'
        : '${widget.driver1Id}_${widget.user1Id}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map(
                      (doc) =>
                          Message.fromMap(doc.data() as Map<String, dynamic>),
                    )
                    .toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message.senderId == widget.user1Id;

                    // Using ChatBubble widget for message display
                    return ChatBubble(
                      message: message.text,
                      isCurrentUser: isUserMessage,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
