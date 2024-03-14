import 'package:chat/Components/flush_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../Components/components.dart';
import '../../Services/user_provider.dart';
import '../authentication/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    userProvider.getCurrentUser();
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
        title: const Text('Settings'),
      ),
      body:               Provider.of<UserProvider>(context, listen: true).loading?const Center(child: CircularProgressIndicator(),):
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
                  userProvider.currentUser.isEmpty?const Center(child: Text("No User Found"),):
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  InkWell(
                    onTap: () {
                      userProvider.uploadImage(context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userProvider.currentUser['image']),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
          
                    children: [
                      Expanded(
                        child: Input(
                          con: null,
                          readOnly: !userProvider.nameEdit,
                          lab: "Name",
                          pre: const Icon(Icons.person_outline),
                          initialValue: userProvider.currentUser['name'],
                          oC: (p0) {
                            userProvider.setUpdateName(p0);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<UserProvider>(context, listen: false).nameEdit) {
                            if (userProvider.updateName.isNotEmpty) {
                              userProvider.setnameEdit(false);
                            }else{
                              showFlushBar("Name can't be empty");
                            }
                          } else {
                            userProvider.setnameEdit(true);
                          }
                        },
                        child: Provider.of<UserProvider>(context, listen: true).nameEdit?
                        Provider.of<UserProvider>(context, listen: true).loadingUpdateName?const Center(child: CircularProgressIndicator(),):
                        const Text('Save'):const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
          
                    children: [
                      Expanded(
                        child: Input(
                          con: null,
                          readOnly: !userProvider.familyNameEdit,
                          lab: "Family Name",
                          pre: const Icon(Icons.person_outline),
          
                          initialValue: userProvider.currentUser['familyName'],
                          oC: (p0) {
                            userProvider.setUpdateFamilyName(p0);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<UserProvider>(context, listen: false).familyNameEdit) {
                             if (userProvider.updateFamilyName.isNotEmpty) {
                              userProvider.setfamilyNameEdit(false);
                             }else{
                               showFlushBar("Family Name can't be empty");
                             }
                          } else {
                            userProvider.setfamilyNameEdit(true);
                          }
                        },
                        child: Provider.of<UserProvider>(context, listen: true).familyNameEdit?
                        Provider.of<UserProvider>(context, listen: true).loadingUpdateFamilyName?const Center(child: CircularProgressIndicator(),):
                        const Text('Save'):const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
          
                    children: [
                      Expanded(
                        child: Input(
                          con: null,
                          readOnly: !userProvider.ageEdit,
                          lab: "Age",
                          pre: const Icon(Icons.view_agenda_rounded),
          
                          initialValue: userProvider.currentUser['age'],
                          oC: (p0) {
                            userProvider.setUpdateAge(p0);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<UserProvider>(context, listen: false).ageEdit) {
                            if (userProvider.updateAge.isNotEmpty) {
                              userProvider.setageEdit(false);
                            } else {
                              showFlushBar("Age can't be empty");
                            }
          
                          } else {
                            userProvider.setageEdit(true);
                          }
                        },
                        child: Provider.of<UserProvider>(context, listen: true).ageEdit?
                        Provider.of<UserProvider>(context, listen: true).loadingUpdateAge?const Center(child: CircularProgressIndicator(),):
                        const Text('Save'):const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
          
                    children: [
                      Expanded(
                        child: Input(
                          con: null,
                          readOnly: !userProvider.phoneEdit,
                          lab: "Phone",
                          pre: const Icon(Icons.phone),
                          initialValue: userProvider.currentUser['phone'],
                          oC: (p0) {
                            userProvider.setUpdatePhone(p0);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<UserProvider>(context, listen: false).phoneEdit) {
                            userProvider.setphoneEdit(false);
                          } else {
                            userProvider.setphoneEdit(true);
                          }
                        },
                        child: Provider.of<UserProvider>(context, listen: true).phoneEdit?
                        Provider.of<UserProvider>(context, listen: true).loadingUpdatePhone?const Center(child: CircularProgressIndicator(),):
                        const Text('Save'):const Text('Edit'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle:  const TextStyle( fontWeight: FontWeight.bold, color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  userProvider.logout();
                },
                child: const Text('Sign Out'),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
