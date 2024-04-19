import 'dart:async';
import 'dart:convert';
import 'package:chat/Screens/another_person/another_person_screen.dart';
import 'package:firebase_database/firebase_database.dart';
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
 late DatabaseReference dbRef=  FirebaseDatabase.instance.reference().child("Users").child(FirebaseAuth.instance.currentUser!.uid).child("Messages").child(widget.UID);
 List ChatList = [];
@override
  void initState() {
    // TODO: implement initState
  vari();
  dbRef.onChildAdded.listen((event) {
    setState(() {
      ChatList.insert(0, event.snapshot.value); // Insert new items at the beginning of the list
    });
  });
  dbRef.onChildRemoved.listen((event) {
    print(event.snapshot.value);
    Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      ChatList.removeWhere((element) => element['key'] == values['key']);
    });
  });
    super.initState();
  }
  String? image;
  vari()async{
      image= await Provider.of<UserProvider>(context, listen: false)
          .getMyImage();


  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    var userProvider = Provider.of<UserProvider>(context, listen: false);
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
                    Expanded(child: ListView.builder(
                      controller: listScrollController,
                      itemCount: ChatList.length,
                      reverse: true,

                      itemBuilder: (context, index) {
                        bool fromcurrent = ChatList[index]['MSID'] == FirebaseAuth.instance.currentUser!.uid;
                        print (ChatList[index]['MSID']);

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
                                              ChatList[index]
                                          );
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
                              fromcurrent
                                  ?  SizedBox()
                                  :  CircleAvatar(
                                backgroundImage: NetworkImage(
                                    ( Provider.of<UserProvider>(context, listen: false)
                                        .anotherPerson['image']?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png")),
                              ),
                              // SizedBox(width: ,),
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ChatList[index]['content'],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      if (ChatList[index]['time']!=null)
                                      Text(
                                        ChatList[index]['time']??"",
                                        style: TextStyle(
                                            color: Colors.black54, fontSize: 12),)
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: ,
                              // ),
                              fromcurrent
                                  ?  CircleAvatar(
                                      backgroundImage: NetworkImage(
                                                  (image??
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png")),
                                    )
                                  :  SizedBox()
                            ],
                          ),
                        );
                      },
                    )),
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
