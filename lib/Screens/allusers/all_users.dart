import 'package:chat/Services/user_provider.dart';
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
              child: Provider.of<UserProvider>(context, listen: true).loading?const Center(child: CircularProgressIndicator(),):
              userProvider.filteredUsers.isEmpty?const Center(child: Text("No Users Found"),):
              RefreshIndicator(
                onRefresh: () async {
                  userProvider.getAllUsers();
                },
                child: ListView.builder(
                  itemCount: userProvider.filteredUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        userProvider.getChatWithUser(
                            userProvider.filteredUsers[index]['userid'],

                            context);
                        },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userProvider.filteredUsers[index]['image']),
                        radius: 25,
                      ),
                      title: Text(userProvider.filteredUsers[index]['name']),
                      subtitle: Text(userProvider.filteredUsers[index]['email']),

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
