import 'package:chat/Services/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/components.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    userProvider.getAllUsers();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    userProvider.getAllChats();
  }
  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(

      appBar: AppBar(
        title: Text('All Users'),
        elevation: 0.5,

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Input(
              con:userProvider.searchControllerUsers,
              lab: "Search",
              pre: const Icon(Icons.search),
              oC: (p0) {
                userProvider.searchUsers();
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
                    final users = snapshot.data!.docs
                        .where((doc) => doc['userid'] != FirebaseAuth.instance.currentUser?.uid)
                        .map((doc) => doc.data()) // Safe casting
                        .toList();
                    if (users.isEmpty) {
                      return const Center(child: Text("No users found"),);
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
