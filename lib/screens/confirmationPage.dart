import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surplus/screens/uploadData.dart';

import 'feedScreen.dart';

class ConfirmationPage extends StatelessWidget {
 String title,tid;
  ConfirmationPage(this.title,this.tid);

 final _auth = FirebaseAuth.instance;
 User loggedInUser;
 void getCurrentUser() async {
   try {
     final user = await _auth.currentUser;
     if (user != null) {
       loggedInUser = user;
       print(loggedInUser.uid);

     }
   } catch (e) {
     print(e);
   }
 }
 deleteListing(){
   CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
   collectionReference.doc(loggedInUser.uid).collection('myfeed').snapshots().forEach((element) {
     for (int i = 0; i < element.size; i++) {
       // print(element.docs[i].id);
       // print(element.docs[i].data()['userID']);
       collectionReference.doc(loggedInUser.uid).collection('myfeed').doc(tid.toString()).delete();

     }
   });

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle
                    ),
                    child: Container(
                      margin: EdgeInsets.all(50.0),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        iconSize: 50.0,
                        icon: Icon(Icons.done,color: Colors.white,),
                        onPressed: () {

                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 50,),
                  Text('Congratulations!!!!',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  SizedBox(height: 50,),
                  Text('You have listed'),
                  SizedBox(height: 50,),
                  Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 50,),
                  Text('as surplus'),
                  SizedBox(height: 50,),
                  ButtonTheme(
                    minWidth: 300.0,

                    child: RaisedButton(

                      color: Colors.orange,
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),    borderRadius: BorderRadius.circular(18.0),),
                      child: Text('Return to home'),
                      onPressed: (){

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => UploadData()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Changed your mind',style: TextStyle(fontWeight: FontWeight.bold),),
                      GestureDetector(
                          onTap: (){

                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "ALERT",
                              desc: "Are you sure you want to delete $title  ",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "yes",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    getCurrentUser();
                                    print("hello");
                                    Future.delayed(const Duration(seconds: 1), ()
                                    {
                                      deleteListing();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => FeedScreen()),
                                          (route) => false);
                                    });
                                  },
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                                DialogButton(
                                  child: Text(
                                    "no",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(116, 116, 191, 1.0),
                                    Color.fromRGBO(52, 138, 199, 1.0)
                                  ]),
                                )
                              ],
                            ).show();



                          },
                          child: Text(" Remove listing",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red ),)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}









