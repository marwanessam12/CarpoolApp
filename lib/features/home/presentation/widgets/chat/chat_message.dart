import 'package:carpool/features/home/presentation/widgets/chat/chatmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendMessage(String userId, String driverId, String text) async {
  final message = Message(
    senderId: userId,
    text: text,
    timestamp: DateTime.now(),
  );

  final chatId = userId.compareTo(driverId) < 0
      ? '$userId\_$driverId'
      : '$driverId\_$userId';
  final messagesCollection = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages');

  await messagesCollection.add(message.toMap());
}
