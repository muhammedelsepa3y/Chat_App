import 'package:chat/Components/flush_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

import '../../Components/components.dart';
import '../../Services/user_provider.dart';
import '../authentication/login_screen.dart';

class AnotherPersonScreen extends StatefulWidget {
  const AnotherPersonScreen({super.key});

  @override
  State<AnotherPersonScreen> createState() => _AnotherPersonScreenState();
}

class _AnotherPersonScreenState extends State<AnotherPersonScreen> {

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProvider.anotherPerson['image']),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  Text(userProvider.anotherPerson['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(userProvider.anotherPerson['email'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                      ),
                      Text('Family Name'+': '+userProvider.anotherPerson['familyName'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Age'+': '+userProvider.anotherPerson['age'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone'+': '+userProvider.anotherPerson['phone'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      IconButton(
                        onPressed: ()async {
                          bool? res = await FlutterPhoneDirectCaller.callNumber(userProvider.anotherPerson['phone']);
                          print (res);

                        },
                        icon: const Icon(Icons.call),
                      ),
                      ]),


                  //Text(userProvider.anotherPerson['address'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
