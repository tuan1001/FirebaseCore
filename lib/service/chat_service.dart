import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasecore/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatServie {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiveId, String message, String type) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    Message newMessage =
        Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiveId, message: message, type: type, timestamp: timestamp);

    List<String> ids = [currentUserId, receiveId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  Future<void> sendImage(String receiveId, String message, String type, File? imageFile) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email.toString();
    int status = 1;

    String fileName = const Uuid().v1();
    List<String> ids = [currentUserId, receiveId];
    ids.sort();
    String chatRoomId = ids.join('_');
    final Timestamp timestamp = Timestamp.now();
    var ref = FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((onError) async {
      await fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(fileName).delete();
      status = 0;
      return;
    });
    Message newMessage =
        Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiveId, message: message, type: type, timestamp: timestamp);
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(fileName).set(newMessage.toMap(), SetOptions(merge: true));
      print('image $imageUrl');
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}
