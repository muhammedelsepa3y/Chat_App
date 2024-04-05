import 'package:chat/Components/flush_bar.dart';
import 'package:chat/Screens/authentication/login_screen.dart';
import 'package:chat/Screens/settings/settings_screen.dart';
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
  child:
  Provider.of<UserProvider>(context, listen: true).loading?const Center(child: CircularProgressIndicator(),):
     Provider.of<UserProvider>(context,listen: true).filteredChats.isEmpty
          ?const Center(child: Text('No Chats'),):
      RefreshIndicator(
        onRefresh: () async {
          userProvider.getAllChats();
        },
        child: ListView.builder(
          itemCount: Provider.of<UserProvider>(context,listen: true).filteredChats.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                userProvider.getChatWithUser(
                    userProvider.filteredChats[index]['userid'],);
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userProvider.filteredChats[index]['image']),
                radius: 25,
              ),
              title: Text(userProvider.filteredChats[index]['name']),
              subtitle: Text(userProvider.filteredChats[index]['email']),

            );
          },
        ),
      ),

),
            const SizedBox(
              height: 20,
),

          ],
        ),
      ),
    );
  }
}
