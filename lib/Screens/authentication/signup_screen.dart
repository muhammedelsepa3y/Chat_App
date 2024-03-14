import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Components/components.dart';
import '../../Services/user_provider.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
   SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(

      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  const SizedBox(
                    height: 18,
                  ),



                  const Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Input(
                    con: userProvider.nameController,
                    lab: "Name",
                    pre: const Icon(Icons.person_outline),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),Input(
                    con: userProvider.familyNameController,
                    lab: "Family Name",
                    pre: const Icon(Icons.person_outline),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Family Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: userProvider.emailController,
                    lab: "Email",
                    enter: TextInputType.emailAddress,
                    pre: const Icon(Icons.email),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),


                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    con: userProvider.ageController,
                    lab: "Age",
                    pre: const Icon(Icons.view_agenda_rounded),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Age is required";
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: userProvider.phoneController,
                    lab: "Phone",
                    enter: TextInputType.phone,
                    pre: const Icon(Icons.phone),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Phone is required";
                      }
                      return null;
                    },
                  ),


                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: userProvider.passwordController,
                    lab: "Password",

                    pre: const Icon(Icons.lock),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Password is required";
                      }
                      return null;
                    },
                    isObsecure: Provider.of<UserProvider>(context, listen: true).secure,
                    suf: Provider.of<UserProvider>(context, listen: true).secure ? Icons.visibility : Icons.visibility_off,
                    suffunf: () {
                      userProvider.setSecure();
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: userProvider.confirmPasswordController,
                    lab: "Repeat Password",
                    pre: const Icon(Icons.lock),
                    validate: (p0) {
                      if (p0 == "" ) {
                        return "Password is required";
                      }else if(p0 != userProvider.passwordController.text){
                        return "Password does not match";
                      }
                      return null;
                    },
                    isObsecure: Provider.of<UserProvider>(context, listen: true).secure2,
                    suf: Provider.of<UserProvider>(context, listen: true).secure2 ? Icons.visibility : Icons.visibility_off,
                    suffunf: () {
                      userProvider.setSecure2();
                    },
                  ),


                  const SizedBox(
                    height: 25,
                  ),
                  loginButton(
                    buttonText: "Register",
                        () async {
                      if (formkey.currentState!.validate()){
                        FocusScope.of(context).unfocus();
                        await userProvider.signup();
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Exiting User?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),),
                        GestureDetector(
                          onTap: (){
                            userProvider.disposeAlldata();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                          },
                          child: Text("Sign in Now",style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
