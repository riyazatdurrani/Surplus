import 'package:flutter/material.dart';
import 'package:surplus/authentication/login.dart';
import 'package:surplus/models/authmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController =  TextEditingController();
  TextEditingController phoneController =  TextEditingController();
 // TextEditingController passwordController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:60,left: 20,right: 20 ),
          child: Column(
            children: [
              Image.asset('assets/images/Group(4).png'),
              SizedBox(height: 40,),
              InputBox(Text:'Name',textEditingController: nameController),
              SizedBox(height: 40,),
              InputBox(Text:'Phone Number (ex: 7051525357)',textEditingController: phoneController),
              SizedBox(height: 40,),
             // InputBox(Text:'Password',textEditingController: passwordController),
             // SizedBox(height: 40,),

              AuthButton(text: 'Sign Up', phoneController: phoneController,nameController: nameController,),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",style: TextStyle(fontWeight: FontWeight.bold),),

                  GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>Login()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red ),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
