import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/ui/views/chat/add_member_page.dart';

import 'package:firebasecore/ui/views/group/group_chat_room_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({Key? key}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).collection('groups').get().then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Get.to(() => GroupChatRoom(
                          groupChatId: groupList[index]['id'],
                          groupName: groupList[index]['name'],
                        ));
                  },

                  //  => Navigator.of(context).push(
                  //     // MaterialPageRoute(
                  //     //   builder: (_) => GroupChatRoom(
                  //     //     groupName: groupList[index]['name'],
                  //     //     groupChatId: groupList[index]['id'],
                  //     //   ),
                  //     // ),
                  //     ),
                  leading: const Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddMemberPage(),
          ),
        ),
        tooltip: "Create Group",
        child: const Icon(Icons.create),
      ),
    );
  }
}
