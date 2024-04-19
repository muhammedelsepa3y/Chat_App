import 'package:chat/Components/flush_bar.dart';
import 'package:chat/Screens/authentication/login_screen.dart';
import 'package:chat/Screens/settings/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../Components/components.dart';
import '../../Services/user_provider.dart';
import '../allusers/all_users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    userProvider.getAllChats();
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        showFlushBar("New Message, You have a new message");
        userProvider.getChatWithUser(value.data['id']);
      }
    });
  }
//FirebaseAuth.instance.signOut();
  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AllUsers()));
        },
        child: const Icon(Icons.message),
      ),
      appBar: AppBar(
        title: Text('Chats App'),
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Input(
              con:userProvider.searchControllerChats,
              lab: "Search",
              pre: const Icon(Icons.search),
              oC: (p0) {
                userProvider.searchChats();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .orderBy("name", descending: false )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    if (snapshot.hasData) {
                      //final users = (snapshot.data! as QuerySnapshot).docs.where((element) => element['userid']!=FirebaseAuth.instance.currentUser!.uid).map((e) => e.data()).toList();
                      final users = (snapshot.data! as QuerySnapshot).docs;
                      //var snapshott = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Messages").get();
                      // if (snapshott.docs.isEmpty) {
                      //   myChats=[];
                      //   filteredChats=[];
                      //   setLoad(false);
                      //   notifyListeners();
                      //   return;
                      // }
                      // List userIDS=snapshott.docs.map((e) => e.id).toList();
                      // var snapshot2 = await FirebaseFirestore.instance.collection("Users").where("userid", whereIn: userIDS).get();
                      // myChats=snapshot2.docs;
                      if (users.isEmpty) {
                        return const Center(child: Text("No Chats found"),);
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              userProvider.getChatWithUser(
                                users[index]['userid'],);
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(users[index]['image']),
                              radius: 25,
                            ),
                            title: Text(users[index]['name']),
                            subtitle: Text(users[index]['email']),

                          );
                        },
                      );
                    }

                    return const Center(child: Text("Some error occured"),);
                  }
              ),),
            const SizedBox(
              height: 20,
),

          ],
        ),
      ),
    );
  }
}
