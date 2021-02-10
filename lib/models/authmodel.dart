

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:surplus/screens/feedScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surplus/screens/otpscreen.dart';




import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:surplus/screens/confirmationPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class InputBox extends StatelessWidget {
  String Text;

  TextEditingController textEditingController;
  InputBox({this.Text, this.textEditingController});


  @override

  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(10,2,10,2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.red)
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: Text,
        ),
        onChanged: (v){
        //  print("On change <ethod:${textEditingController.text}");
        },
      ),
    );
  }
}

class AuthButton extends StatefulWidget {

  String text;
  TextEditingController nameController;
  TextEditingController phoneController;
  AuthButton({this.text,this.phoneController,this.nameController,});

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('FeedNumber');
  var found=0;
  final _auth = FirebaseAuth.instance;

  checkUser() async{
    var allNumber=[];
    setState(() {
      allNumber=[];
    });

    var snapshot = await collectionReference.get();

    snapshot.docs.forEach((result) {
      collectionReference
          .doc(result.id).snapshots().listen((event) {

          allNumber.add(event.data()['phoneNumber'])  ;
print(allNumber);

          if(widget.phoneController.text.toString()==event.data()['phoneNumber']){

            setState(() {

              found=1;
            });

          }


      });
    });

  }
@override
  void initState() {
   setState(() {
     found=0;
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Container(
      width:100,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red)
      ),
      child: MaterialButton(
        onPressed: () {

          Map<String, String>name = {
            'phoneNumber': widget.phoneController.text.toString(),
          };
          if (widget.text == "Sign Up") {

            checkUser();

            Future.delayed(const Duration(seconds: 2), ()
            {

              if (found == 1) {
                Alert(context: context,
                    title: "ALERT!!",
                    desc: "You are already registered").show();
                setState(() {
                  found = 0;
                });
              }
              else {
                collectionReference.add(name).then((value) =>
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OTPScreen(widget.phoneController.text,
                                widget.nameController.text))));
              }
              setState(() {
                found=0;
              });
            });

          }




          else {
            checkUser();

            Future.delayed(const Duration(seconds: 2), ()
            {

              if (found == 0) {
                Alert(context: context,
                    title: "ALERT!!",
                    desc: "You are not signed up").show();
                // setState(() {
                //   found = 0;
                // });
              }
              else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OTPScreen(widget.phoneController.text,
                            widget.nameController.text)));
              }
            });
          }
          },
        child: Text(
            widget.text,style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold )
        ),
      ),
    );
  }
}




