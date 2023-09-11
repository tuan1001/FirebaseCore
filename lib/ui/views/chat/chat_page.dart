import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/service/chat_service.dart';
import 'package:firebasecore/ui/utils/widgets/items/chat_bubble.dart';
import 'package:firebasecore/ui/utils/widgets/textfileds/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserUid;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserUid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatServie chatServie = ChatServie();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServie.sendMessage(widget.receiverUserUid, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  _buildMessagesList() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
        return ListView.builder(
          itemBuilder: (context, index) {
            return _buildMessagesItem(querySnapshot.docs[index]);
          },
          itemCount: querySnapshot.docs.length,
        );
      },
      stream: chatServie.getMessages(auth.currentUser!.uid, widget.receiverUserUid),
    );
  }

  _buildMessagesItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    var alignment = data['senderId'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: data['senderId'] == auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: data['senderId'] == auth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [Text(data['senderEmail'].toString()), ChatBubble(message: data['message'])],
      ).paddingAll(8),
    );
  }

  _buildMessageInput() {
    return Row(
      children: [
        Expanded(child: TextFieldCus(controller: messageController, hintText: 'Type a message')),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }
}
