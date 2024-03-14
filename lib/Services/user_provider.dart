import 'dart:convert';
import 'dart:io';

import 'package:chat/Components/flush_bar.dart';
import 'package:chat/Screens/home/home_screen.dart';
import 'package:chat/Services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../Screens/authentication/login_screen.dart';
import '../Screens/chat/chat.dart';
class UserProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool nameEdit=false;
  String updateName="";
  bool loadingUpdateName=false;
  setLoadingUpdateName(bool val){
    loadingUpdateName=val;
    notifyListeners();
  }
  setUpdateName(String val){
    updateName=val;
    notifyListeners();
  }
  setnameEdit(bool val){
    if (val==false) {
      setLoadingUpdateName(true);
      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "name": updateName
      }).then((value) {
        setLoadingUpdateName(false);
        showFlushBar("Name Updated Successfully",isError: false);
      }).catchError((e){
        setLoadingUpdateName(false);
        showFlushBar("Something went wrong ${e.toString()}");
      });
    }
    nameEdit=val;
    notifyListeners();
  }
  TextEditingController familyNameController = TextEditingController();
  bool familyNameEdit=false;
  String updateFamilyName="";
  bool loadingUpdateFamilyName=false;
  setLoadingUpdateFamilyName(bool val){
    loadingUpdateFamilyName=val;
    notifyListeners();
  }
  setfamilyNameEdit(bool val){
    if (val==false) {
      setLoadingUpdateFamilyName(true);
      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "familyName": updateFamilyName
      }).then((value) {
        setLoadingUpdateFamilyName(false);
        showFlushBar("Family Name Updated Successfully",isError: false);
      }).catchError((e){
        setLoadingUpdateFamilyName(false);
        showFlushBar("Something went wrong ${e.toString()}");
      });
    }
    familyNameEdit=val;
    notifyListeners();
  }

  setUpdateFamilyName(String val){
    updateFamilyName=val;
    notifyListeners();
  }
  TextEditingController phoneController = TextEditingController();
  bool phoneEdit=false;
  String updatePhone="";
  bool loadingUpdatePhone=false;
  setLoadingUpdatePhone(bool val){
    loadingUpdatePhone=val;
    notifyListeners();
  }
  setphoneEdit(bool val){
    if (val==false) {
      setLoadingUpdatePhone(true);
      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "phone": updatePhone
      }).then((value) {
        setLoadingUpdatePhone(false);
        showFlushBar("Phone Updated Successfully",isError: false);
      }).catchError((e){
        setLoadingUpdatePhone(false);
        showFlushBar("Something went wrong ${e.toString()}");
      });
    }
    phoneEdit=val;
    notifyListeners();
  }
  setUpdatePhone(String val){
    updatePhone=val;
    notifyListeners();
  }
  TextEditingController searchControllerChats = TextEditingController();
  TextEditingController searchControllerUsers = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool ageEdit=false;
  String updateAge="";
  bool loadingUpdateAge=false;
  setLoadingUpdateAge(bool val){
    loadingUpdateAge=val;
    notifyListeners();
  }
  setageEdit(bool val){
    if (val==false) {
      setLoadingUpdateAge(true);
      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "age": updateAge
      }).then((value) {
        setLoadingUpdateAge(false);
        showFlushBar("Age Updated Successfully",isError: false);
      }).catchError((e){
        setLoadingUpdateAge(false);
        showFlushBar("Something went wrong ${e.toString()}");
      });
    }
    ageEdit=val;
    notifyListeners();
  }
  setUpdateAge(String val){
    updateAge=val;
    notifyListeners();
  }
  TextEditingController confirmPasswordController = TextEditingController();
  bool secure = true;
  bool secure2 = true;
  setSecure() {
    secure = !secure;
    notifyListeners();
  }
  setSecure2() {
    secure2 = !secure2;
    notifyListeners();
  }
  disposeAlldata(){
    emailController.text="";
    passwordController.text="";
    nameController.text="";
    familyNameController.text="";
    phoneController.text="";
    ageController.text="";
    confirmPasswordController.text="";
    secure2=true;
    secure=true;
     searchControllerChats.text="";
      searchControllerUsers.text="";
      nameEdit=false;
      familyNameEdit=false;
      phoneEdit=false;
      ageEdit=false;
      updateName="";
      updateFamilyName="";
      updatePhone="";
      updateAge="";
      notifyListeners();
  }


 login() async {
    EasyLoading.show(status: 'loading...');
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      ).then((value) async
      {
        EasyLoading.dismiss();
        Navigator.of(NavigationService.context!).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()));
        disposeAlldata();

      }).
      catchError((e){
        EasyLoading.dismiss();
        if (e.code == 'user-not-found') {
          showFlushBar("No user found for that email");
        }
        else if (e.code == 'wrong-password') {
          showFlushBar("Wrong password provided for that user");
        } else if(e.code=="invalid-email"){
          showFlushBar("Invalid Email");
        }else if(e.code=="invalid-credential"){
          showFlushBar("Invalid Credential");
        }
        else{
          showFlushBar("Something went wrong ${e.code}");
        }
      });
  }
  signup() async  {
      EasyLoading.show(status: 'loading...');
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? token = await messaging.getToken();
        await FirebaseFirestore.instance
            .collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).set({
          "name": "${nameController.text}",
          "email": "${emailController.text}",
          "familyName": "${familyNameController.text}",
          "userid": FirebaseAuth.instance.currentUser!.uid,
          "phone": phoneController.text,
          "age": ageController.text,
          "fcm":[token],
          "image":"https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
        });
        EasyLoading.dismiss();
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(NavigationService.context!, MaterialPageRoute(builder: (context) => HomeScreen()));
          showFlushBar("Account Created Successfully",isError: false);
          disposeAlldata();
        });
      } on FirebaseException catch (e)  {
        EasyLoading.dismiss();
        if (e.code == 'weak-password') {
          showFlushBar("The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          showFlushBar("The account already exists for that email.");
        }
        else {
          showFlushBar("Something went wrong ${e.code}");
        }
      }
    }


  final String serverToken = "AAAAHcEVzN8:APA91bEVz0q_QI1XXbEt6AHBHqbWJgNbFEGjaaycOjmFf2wgIUQgYlp5BRv7O1dJEbU1aTN2sbLu32vGNd14_H4yF9tX7GD8iEDX7xPu3LhVsxVmKk1X7Qkxyv6tR-iULN8Eo-2rsS7-";


  sendAndRetrieveMessage(String name,String message,String time,String targetToken) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$message',
            'title': '$name'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': FirebaseAuth.instance.currentUser!.uid,
          },
          'to': targetToken,
        },
      ),
    );
  }
 List myChats=[];
  List filteredChats=[];
  getAllChats() async {
    var snapshot = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Messages").get();
    if (snapshot.docs.isEmpty) {
        myChats=[];
        filteredChats=[];
        notifyListeners();
        return;
    }
    List userIDS=snapshot.docs.map((e) => e.id).toList();

    var snapshot2 = await FirebaseFirestore.instance.collection("Users").where(
        "userid", whereIn: userIDS).get();
    myChats=snapshot2.docs;
    filteredChats=snapshot2.docs;
    notifyListeners();

  }
  List filteredUsers=[];
  List allUsers=[];
  bool loading=false;
  setLoad(bool val) {
    loading = val;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

   getAllUsers()async {
    setLoad(true);
    var snapshot = await FirebaseFirestore.instance.collection("Users").get();
    allUsers=snapshot.docs.where((element) => element.id!=FirebaseAuth.instance.currentUser!.uid).toList();
    filteredUsers=snapshot.docs.where((element) => element.id!=FirebaseAuth.instance.currentUser!.uid).toList();
    setLoad(false);
    notifyListeners();
}

  searchUsers() {
    if (searchControllerUsers.text.isEmpty) {
      filteredUsers = allUsers;
    }
    filteredUsers = allUsers.where((element) => element['name'].toString().toLowerCase().contains(searchControllerUsers.text.toLowerCase())).toList();
    notifyListeners();
  }
  searchChats() {
    if (searchControllerChats.text.isEmpty) {
      filteredChats = myChats;
    }
    filteredChats = myChats.where((element) => element['name'].toString().toLowerCase().contains(searchControllerChats.text.toLowerCase())).toList();
    notifyListeners();
  }

   logout() async{
    Navigator.pushAndRemoveUntil(NavigationService.context!, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
   Future.delayed(Duration(milliseconds: 200), ()
    {
      FirebaseAuth.instance.signOut();
      showFlushBar("Logged Out Successfully", isError: false);
    });
  }

   Map currentUser={};

   getCurrentUser() async{
     setLoad(true);
    var snapshot = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    currentUser=snapshot.data()!;
    setLoad(false);
    notifyListeners();
   }

   uploadImage(context)async {
     XFile? image;
     showDialog(context: context, builder:
      (context){
        return AlertDialog(
          title: const Text("Choose Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: ()async {
                  Navigator.pop(context);
                  image=await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image!=null) {
                    uploadImageToFirebase(image!);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () async{
                  Navigator.pop(context);
                  image=await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image!=null) {
                    uploadImageToFirebase(image!);
                  }
                },
              ),
            ],
          ),
        );
      }
     );


   }

  void uploadImageToFirebase(XFile image) async{
    setLoad(true);
    var ref = FirebaseStorage.instance.ref().child("Users").child(FirebaseAuth.instance.currentUser!.uid).child("image");
    await ref.putFile(File(image!.path));
    var url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "image": url
    });
    getCurrentUser();
  }
  TextEditingController messageController = TextEditingController();

   setMessage(String val){
      messageController.text=val;
     notifyListeners();
   }
  sendMessage(String targetUID) async {
     String message=messageController.text;
    var currentUser=await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).get();
    String currentUserName=currentUser['name'];
    setMessage("");
    int temp= DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Messages')
          .doc(targetUID)
          .collection('chats')
          .add({
        "MSID": FirebaseAuth.instance.currentUser?.uid,
        "MRID": targetUID,
        "content": message,
        "Time": temp,
      }).then((value) {
         FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('Messages')
            .doc(targetUID).set({"name":currentUser['name']});
        getMessages(targetUID);
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(targetUID)
          .collection('Messages')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("chats")
          .add({
        "MSID": FirebaseAuth.instance.currentUser?.uid,
        "MRID": targetUID,
        "content": message,
        "Time": temp,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(targetUID)
            .collection('Messages')
            .doc(FirebaseAuth.instance.currentUser?.uid).set({"name":currentUserName});
      });

      var snapshot = await FirebaseFirestore.instance.collection("Users").doc(targetUID).get();
      if (snapshot['fcm']!=null) {
        for (var token in snapshot['fcm']) {
          sendAndRetrieveMessage(currentUserName
              ,message,DateTime.now().millisecondsSinceEpoch.toString(),token);
        }
      }

  }
  List messages=[];
   getMessages(String targetUID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Messages')
        .doc(targetUID)
        .collection('chats')
        .orderBy("Time", descending: true)
        .get();
    messages=snapshot.docs;
    print (messages);
    notifyListeners();
  }

  getChatWithUser(uid, BuildContext context) {
     // iwant to remove every thing instack unliss homescreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Chat(UID: uid)),
          (Route<dynamic> route) => route.isFirst,
    );
    getAnotherPersonProfile(uid, context);
    getMessages(uid);
  }
  Map anotherPerson={};
  getAnotherPersonProfile(uid, BuildContext context) {
    setLoad(true);
    FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) {
      anotherPerson=value.data()!;
      setLoad(false);
      notifyListeners();
    });
  }

  void clearMessagesAndAnotherPerson() {
    messages=[];
    anotherPerson={};
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

   deleteMessage(message)async {
    String targetUID=message['MRID'];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Messages')
        .doc(targetUID)
        .collection('chats').where("content",isEqualTo: message['content']).where("Time",isEqualTo: message['Time']).get().then((value) {
      value.docs.first.reference.delete();
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(targetUID)
        .collection('Messages')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('chats').where("content",isEqualTo: message['content']).where("Time",isEqualTo: message['Time']).get().then((value) {
      value.docs.first.reference.delete();
    });
    messages.remove(message);
    getMessages(targetUID);

    }




}
