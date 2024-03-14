import 'dart:async';
import 'dart:convert';
import 'package:chat/Screens/another_person/another_person_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/user_provider.dart';

class Chat extends StatefulWidget {
  String UID;

  Chat({required this.UID});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ScrollController listScrollController = ScrollController();

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.getAllChats();
    userProvider.clearMessagesAndAnotherPerson();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Provider.of<UserProvider>(context, listen: true).loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<UserProvider>(context, listen: false)
                                  .anotherPerson['image']),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            Provider.of<UserProvider>(context, listen: false)
                                .anotherPerson['name'],
                            maxLines: 2,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AnotherPersonScreen()));
                          },
                          icon: const Icon(
                            Icons.info,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child:
                        StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .collection('Messages')
                                    .doc(widget.UID)
                                    .collection('chats')
                                    .orderBy("Time", descending: true)
                                    .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                              itemBuilder: (context, index) {
                                bool fromcurrent = (snapshot.data! as QuerySnapshot).docs[index]['MSID'] == FirebaseAuth.instance.currentUser?.uid;

                                return GestureDetector(
                                  onLongPress: () {
                                    if (fromcurrent) {
                                       showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Delete"),
                                              content: const Text(
                                                  "Are you sure you want to delete this message?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    userProvider.deleteMessage(
                                                        (snapshot.data! as QuerySnapshot).docs[index]);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: fromcurrent
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                            top: 10,
                                            bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: (fromcurrent
                                                ? Colors.blue[200]
                                                : Colors.grey.shade200),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            (snapshot.data! as QuerySnapshot).docs[index]['content'],
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          }
                        ),

                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 6, bottom: 6, top: 6, right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                      ),
                      width: double.infinity,
                      child: Form(
                        key: formkey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: userProvider.messageController,
                                onChanged: (value) {
                                  userProvider.setMessage(value);
                                },
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    hintText: "Write a message...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Opacity(
                              opacity:
                                  userProvider.messageController.text.isEmpty
                                      ? 0
                                      : 1,
                              child: FloatingActionButton(
                                mini: true,
                                onPressed: () {
                                  if (userProvider
                                      .messageController.text.isNotEmpty) {
                                    userProvider.sendMessage(widget.UID);
                                  }
                                },
                                backgroundColor: Colors.blue,
                                elevation: 0,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
