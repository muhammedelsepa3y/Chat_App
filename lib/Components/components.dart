// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:spots_msp_project/modules/chats/chats.dart';
// import 'package:spots_msp_project/modules/contact_us/contact_us.dart';
// import 'package:spots_msp_project/modules/profile/profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import '../../modules/about_us/about_us.dart';
// import '../../modules/chats/chat.dart';
//
//
// import '../../modules/edit_profile/edit_profile.dart';
// import '../../modules/enrollment/enrollment.dart';
// import '../../modules/login/login.dart';
//
// import '../../modules/my_events/my_events.dart';
// import '../../modules/payment/payment.dart';
// import 'constants.dart';
//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget loginButton(
    void Function()? function, {
      double widt = double.infinity,
      double heigh = 45,
      bool isUpper = true,
      Color backcolor =Colors.blue,
      Color Textcolor = Colors.white,
      double circular = 25,
      String buttonText = "Login",
      double textSize = 22,
    }) =>
    Container(
      decoration: BoxDecoration(
          color: backcolor, borderRadius: BorderRadius.circular(circular)),
      width: widt,
      height: heigh,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? buttonText.toUpperCase() : buttonText,
          style: TextStyle(color: Textcolor, fontSize: textSize),
        ),
      ),
    );

Widget Input(
    {
      @required TextEditingController? con,
      @required String? lab,
      String hint="",
      bool isObsecure=false,
      void Function(String)? oFS,
      void Function(String)? oC,
      TextInputType enter=TextInputType.visiblePassword,
      @required Icon? pre,
      IconData? suf,
      void Function()? suffunf,
      String? Function(String?)? validate,
      List<TextInputFormatter>? inputFormatters,
      String? initialValue,
      bool readOnly=false

    }) => TextFormField(
  validator:  validate,
  controller: con,
  obscureText: isObsecure,
  onFieldSubmitted:oFS ,
  readOnly: readOnly,
  onChanged: oC,
inputFormatters: inputFormatters,
  keyboardType: enter,
  initialValue: initialValue,
  decoration: InputDecoration(
      labelText: lab,
      hintText: hint,


      border: const OutlineInputBorder(),
      prefixIcon: pre,
      suffixIcon: IconButton(
          onPressed:suffunf,
          icon: Icon(suf))),
);
//
//
//
//
// Widget drawer(context,String name,String img)   {
//   int? online;
//   Future<void> getData() async {
//
//    await FirebaseFirestore.instance.collection("Users").where("Email", isEqualTo:FirebaseAuth.instance.currentUser?.email )
//         .snapshots().listen((value)  {
//             online = value.docs[0]["OnlineWallet"];
//
//
//     });
//
//   }
//
//   Future<void> _showMyDialog(String title , String text) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children:  <Widget>[
//                 Text(text),
//
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//
//               },
//             ),
//
//           ],
//         );
//       },
//     );
//   }
//
//
//
//   getData().then((value)  {});
//     return Drawer(
//       child: ListView(
//         children:  [
//           UserAccountsDrawerHeader(
//             accountEmail:Text("${FirebaseAuth.instance.currentUser!.email}"),
//             accountName: Text(name),
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: img != null ? NetworkImage(img)
//                   : null,
//             ),
//             decoration: const BoxDecoration(color: Colors.black),
//           ),
//
//           ListTile(
//             leading: const Icon(Icons.account_circle),
//             title: const Text("My Profile",style:TextStyle(fontSize: 20),),
//             onTap: (){
//
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>profile()));
//             },
//
//           ),
//           ListTile(
//             leading: const Icon(Icons.edit),
//             title: const Text("Edit Profile",style:TextStyle(fontSize: 20),),
//             onTap: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
//             },
//
//           ),
//           ListTile(
//             leading: const Icon(Icons.search),
//             title: const Text("About Us",style:TextStyle(fontSize: 20)),
//             onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>about_us()));},
//           ),
//           ListTile(
//             leading: const Icon(Icons.message),
//             title: const Text("Chats",style:TextStyle(fontSize: 20)),
//             onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> chats(eventId: 11111,)));},
//           ),
//           ListTile(
//             leading: const Icon(Icons.money),
//             title: const Text("Spots Wallet",style:TextStyle(fontSize: 20)),
//             onTap: (){ _showMyDialog("Spots Wallet","You have \$ ${online} in your wallet");},
//           ),
//           ListTile(
//             leading: const Icon(Icons.credit_card),
//             title:const Text("Payment",style:TextStyle(fontSize: 20)),
//             onTap: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment_PAGE()));
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.event),
//             title:const Text("My Events",style:TextStyle(fontSize: 20)),
//             onTap: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>MyEvents()));
//             },
//           ),
//
//           ListTile(
//             leading: const Icon(Icons.message),
//             title: const Text("Contact Us",style:TextStyle(fontSize: 20)),
//             onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>contact_us()));},
//           ),
//
//           ListTile(
//               leading: const Icon(Icons.logout,color: Colors.red,),
//               title: const Text("Logout",style:TextStyle(fontSize: 20,color: Colors.red)),
//
//               onTap: ()  {
//                 showload();
//                 logout().then((value)
//                 async {
//                   await AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.SUCCES,
//                     headerAnimationLoop: false,
//                     animType: AnimType.TOPSLIDE,
//                     showCloseIcon: true,
//                     closeIcon: const Icon(Icons.close_fullscreen_outlined),
//                     title: 'Logout Successful',
//                     onDissmissCallback: (type) {
//                       debugPrint('Dialog Dissmiss from callback $type');
//                     },
//                     btnOkOnPress: () {
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => const loginScreen()));
//                     },
//                   ).show();
//
//                 });
//               }
//
//           )
//         ],
//       ),
//     );
// }
//
//
// final List<Widget> imageSliders = alleventime
//     .map((item) => Container(
//   child: Container(
//     margin: const EdgeInsets.all(5.0),
//     child: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//         child: Stack(
//           children: <Widget>[
//             Image.asset(item, fit: BoxFit.cover, width: 1000.0),
//             Positioned(
//               bottom: 0.0,
//               left: 0.0,
//               right: 0.0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color.fromARGB(200, 0, 0, 0),
//                       Color.fromARGB(0, 0, 0, 0)
//                     ],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 10.0, horizontal: 20.0),
//
//               ),
//             ),
//           ],
//         )),
//   ),
// ))
//     .toList();
//
// Widget eventCard(context,{
//     required String eventType,
//     required int eventId,
//     required String location,
//      bool? isSuper,
//     required String date,
//     required int Price,
//     required String photo,Color border=Colors.grey,Widget? widg,String bt="Book",void Function()? onPressed}) {
//
//   return Padding(
//     padding: const EdgeInsets.all(0.0),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: border,width: 3),
//
//       ),
//       height: 125,
//
//       child:Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             alignment: Alignment.topRight,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Image.network(photo,height: 110,width: 110,fit:BoxFit.fill ,),
//                     SizedBox(
//                       width: 140,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.blue,
//                             ),
//                             child: MaterialButton(
//                                 onPressed: onPressed,
//                                 child: Text(bt,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
//                           ),
//                           SizedBox(height: 2,),
//                           Text("Location:$location",style: const TextStyle(fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
//                           Text("Date:$date",style: const TextStyle(fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
//                           Text("Price: \$ $Price.00",style: const TextStyle(fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               widg??const SizedBox(),
//
//             ],
//           ),
//
//         ],
//       ),
//
//     ),
//   );
// }
//
// Widget supercb(String s){
//   return Positioned(
//     right: -10,
//     top: 11,
//     child: RotationTransition(
//
//       turns: const AlwaysStoppedAnimation(35/360),
//       child: Container(
//           margin: const EdgeInsetsDirectional.only(start: 0,top: 0),
//           decoration: BoxDecoration(
//
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: const [
//               BoxShadow(
//                   blurRadius: 2,
//                   color: Colors.orangeAccent
//               )
//             ],
//
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Text("Super$s",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
//           )),
//     ),
//   );
// }
//
// Widget buildChatItem(context, String photo, String message, String time, bool isOpen,{required String name})=>GestureDetector(
//   onTap: (){
//    // Navigator.push(context, MaterialPageRoute(builder: (context) => chat(name: name,photo: photo,message: message,)));
//   },
//   child:   Row(
//     children: [
//       Stack(
//         alignment: AlignmentDirectional.topStart,
//         children: [
//           CircleAvatar(radius:30 ,backgroundImage:AssetImage("Assets/$photo")),
//           const CircleAvatar(radius:9 ,backgroundColor:Colors.white),
//           const Padding(
//               padding: EdgeInsetsDirectional.only(top: 3,start:3),
//               child: CircleAvatar(radius:7 ,backgroundColor:Colors.green))
//         ],
//       ),
//       const SizedBox(width: 20,),
//       Expanded(
//         child: Column(
//           crossAxisAlignment:CrossAxisAlignment.start,
//           children: [
//             Text(
//               name,style: const TextStyle(
//               fontSize: 16,
//               fontWeight:FontWeight.bold,
//             ),
//               maxLines:1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height:5),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                       maxLines:2,
//                       overflow: TextOverflow.ellipsis,
//                       message,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal:10),
//                   child: Container(
//                       width: 5,
//                       height: 5,
//                       decoration:const BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle
//                       )
//                   ),
//                 ),
//                 Text(
//                     time
//                 ),
//               ],
//             )
//           ],
//         ),
//       )
//     ],
//   ),
// );
//
//
// Future<void> logout() async {
//   await FirebaseAuth.instance.signOut();
// }
//
//
// Future<void> getuser() async {
//   var user=FirebaseAuth.instance.currentUser;
// }
//
// Widget showload(){
//
//   return Dialog(
//     backgroundColor: Colors.transparent,
//     child: Container(
//       height: 100,
//       width: 100,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Loading...",
//             style: TextStyle(fontSize: 20),
//           )
//         ],
//       ),
//     ),
//   );
//
// }