import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/service/chat_service.dart';
import 'package:firebasecore/ui/utils/widgets/items/chat_bubble.dart';
import 'package:firebasecore/ui/views/group/group_info_page.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key}) : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ChatServie chatServie = ChatServie();
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "senderEmail": auth.currentUser!.email,
        "senderId": auth.currentUser!.uid,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore.collection('groups').doc(groupChatId).collection('chats').add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GroupInfo(
                      groupName: groupName,
                      groupId: groupChatId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('groups').doc(groupChatId).collection('chats').orderBy('time').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.photo),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      var alignment = chatMap['senderId'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft;
      if (chatMap['type'] == "text") {
        return Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment: chatMap['senderId'] == auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: chatMap['senderId'] == auth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [Text(chatMap['senderEmail'].toString()), ChatBubble(message: chatMap['message'])],
          ).paddingAll(8),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['senderEmail'] == auth.currentUser!.displayName ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
