import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasecore/model/message.dart';
import 'package:firebasecore/service/chat_service.dart';
import 'package:firebasecore/ui/utils/widgets/items/chat_bubble.dart';
import 'package:firebasecore/ui/utils/widgets/items/image_thumpnail.dart';
import 'package:firebasecore/ui/utils/widgets/textfileds/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  File? imageFile;
  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    await imagePicker.pickImage(source: ImageSource.gallery).then((value) => {
          if (value != null)
            {
              imageFile = File(value.path),
              uploadImage(),
            }
        });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
    List<String> ids = [auth.currentUser!.uid, widget.receiverUserUid];
    ids.sort();
    String chatRoomId = ids.join('_');
    await chatServie.sendMessage(widget.receiverUserUid, messageController.text, 'img');
    var ref = FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((onError) async {
      await fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(fileName).delete();

      status = 0;
      return;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(fileName).set(
          Message(
                  senderId: auth.currentUser!.uid,
                  senderEmail: auth.currentUser!.email.toString(),
                  receiverId: widget.receiverUserUid,
                  message: imageUrl,
                  type: 'img',
                  timestamp: Timestamp.now())
              .toMap(),
          SetOptions(merge: true));
      print('image $imageUrl');
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServie.sendMessage(widget.receiverUserUid, messageController.text, 'text');
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

  _buildMessagesItem(
    DocumentSnapshot documentSnapshot,
  ) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    var alignment = data['senderId'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft;

    return data['type'] == 'text'
        ? Container(
            alignment: alignment,
            child: Column(
              crossAxisAlignment: data['senderId'] == auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: data['senderId'] == auth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [Text(data['senderEmail'].toString()), ChatBubble(message: data['message'])],
            ).paddingAll(8),
          )
        : data['message'] != ''
            ? InkWell(
                onTap: () {
                  Get.to(() => ImageThumpnail(imageUrl: data['message']));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: data['senderId'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
                    // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: data['message'] != '' ? null : Alignment.center,
                        child: Column(
                          crossAxisAlignment: data['senderId'] == auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          mainAxisAlignment: data['senderId'] == auth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Text(data['senderEmail'].toString()),
                            data['message'] != ''
                                ? Image.network(
                                    data['message'],
                                    fit: BoxFit.cover,
                                  )
                                : const CircularProgressIndicator(),
                          ],
                        )).paddingAll(8)),
              )
            : const SizedBox.shrink();
  }

  _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: TextFieldCus(
                controller: messageController,
                suffixIcon: IconButton(onPressed: () => getImage(), icon: const Icon(Icons.image)),
                hintText: 'Type a message')),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }
}
