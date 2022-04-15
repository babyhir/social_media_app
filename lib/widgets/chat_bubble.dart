import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';

class ChatBubble extends StatelessWidget {

  final ChatModel chatModel;
  final String currentUserID;

  const ChatBubble(this.chatModel,this.currentUserID,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: chatModel.userId == currentUserID ? const Radius.circular(15) : Radius.zero,
          bottomRight:  chatModel.userId == currentUserID ? Radius.zero : const Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: chatModel.userId == currentUserID ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text("By ${chatModel.userName}",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          const SizedBox(height: 5),
          Text(chatModel.message,
            style: const TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}
