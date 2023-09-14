// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/ui/views/group/create_group_page.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).get().then((map) {
      setState(() {
        membersList.add({
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
    print(membersList);
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
    print(membersList);
  }

  //void getUser()
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView(
                    children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
                  ),
                )),
                SizedBox(
                  height: size.height / 20,
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: membersList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            membersList.removeAt(index);
                          });

                          print(membersList);
                        },
                        leading: const Icon(Icons.account_circle),
                        subtitle: Text(membersList[index]['email']),
                        trailing: const Icon(Icons.close),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: const Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          setState(() {
            membersList.add({
              "email": data['email'],
              "uid": data['uid'],
              "isAdmin": false,
            });
          });

          print(membersList);
        },
      );
    } else {
      return Container();
    }
  }
}
