// lib/services/chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to create or get chat ID based on driver and passenger IDs
  Future<String> getOrCreateChat(String driverId, String passengerId) async {
    // Generate a unique chat ID by concatenating both IDs
    String chatId = '${driverId}_$passengerId';

    // Reference to the chat document
    DocumentReference chatDocRef = _firestore.collection('chats').doc(chatId);

    // Check if the chat document already exists
    DocumentSnapshot chatSnapshot = await chatDocRef.get();
    if (!chatSnapshot.exists) {
      // If chat does not exist, create a new chat document
      await chatDocRef.set({
        'driverId': driverId,
        'passengerId': passengerId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId; // Return the chatId for use in ChatScreen
  }
}
