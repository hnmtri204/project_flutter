import 'package:flutter/material.dart';
import 'package:myapp/constants/chat_message.dart';
import 'package:myapp/constants/colors.dart';
import 'package:myapp/models/message_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  List messages = [
    MessageModel(
        message: "Hello",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 1),
        isSeenByReceiver: true),
    MessageModel(
        message: "hi",
        sender: "202",
        receiver: "101",
        timestamp: DateTime(2024, 1, 2),
        isSeenByReceiver: false),
    MessageModel(
        message: "how are you?",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 3),
        isSeenByReceiver: false),
    MessageModel(
        message: "how are you?",
        sender: "101",
        receiver: "202",
        timestamp: DateTime(2024, 1, 3),
        isSeenByReceiver: false,
        isImage: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leadingWidth: 40,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Other User",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => ChatMessage(
                    msg: messages[index], currentUser: "101", isImage: true),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Type a message ..."),
                )),
                IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
