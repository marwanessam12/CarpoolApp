import 'package:carpool/features/home/presentation/widgets/chat/chatmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String driverId;
  final String rideId;

  const ChatScreen({
    required this.userId,
    required this.driverId,
    required this.rideId,
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<String> _messageSuggestions = [
    "Hello",
    "On my way",
    "Waiting for you",
    "Arrived"
  ];

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await sendMessage(widget.userId, widget.driverId, widget.rideId,
          _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatId = widget.rideId; // Use ride ID for the chat context

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Ride') // Collection for ride
                  .doc(chatId) // Document for the specific ride
                  .collection(
                      'chatMessages') // Sub-collection for chat messages
                  .orderBy('timestamp', descending: true) // Order by timestamp
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) =>
                        Message.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                // Use ListView to display messages
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message.senderId == widget.userId;

                    return Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                              color:
                                  isUserMessage ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message suggestions in a scrollable row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            height: 60, // Set a fixed height for the suggestion area
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _messageSuggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color
                        foregroundColor: Colors.blue, // Text color
                      ),
                      onPressed: () {
                        _messageController.text =
                            suggestion; // Insert suggestion into text field
                      },
                      child: Text(suggestion),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Padding for the input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(
      String userId, String driverId, String rideId, String message) async {
    final chatMessage = {
      'senderId': userId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(), // Ensure this is called
    };

    await FirebaseFirestore.instance
        .collection('Ride') // Collection for ride
        .doc(rideId) // Document for the specific ride
        .collection('chatMessages') // Sub-collection for chat messages
        .add(chatMessage); // Add the message to the chat
  }
}
