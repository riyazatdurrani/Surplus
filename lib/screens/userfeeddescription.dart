import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'feedScreen.dart';
class userfeeddescription extends StatefulWidget {
   String title,url,feedid,desc;
   userfeeddescription(this.title,this.url,this.feedid,this.desc);
  @override
  _userfeeddescriptionState createState() => _userfeeddescriptionState();
}

class _userfeeddescriptionState extends State<userfeeddescription> {

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

  taken(){
    Map<String,String>avalibility={
      'avalibility':'0',
    };
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
    var a = collectionReference.doc(loggedInUser.uid).collection('myfeed').doc(widget.feedid).update(avalibility);

    // a.snapshots().listen((event) {
    //   print(event.data()['avalibility']);
    // });
    Alert(
      context: context,
      type: AlertType.success,
      title: "Taken Alert",
      desc: "You have marked this feed as taken, this means this feel is let off.",
      buttons: [
        DialogButton(
          child: Text(
            "GO BACK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();


  }

  deleteListing(){
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
    collectionReference.doc(loggedInUser.uid).collection('myfeed').snapshots().forEach((element) {
      for (int i = 0; i < element.size; i++) {
        print(element.docs[i].id);
        print(element.docs[i].data()['userID']);
        collectionReference.doc(loggedInUser.uid).collection('myfeed').doc(widget.feedid).delete();

      }
    });

  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // body:
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:50.0,left: 20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 20,
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,

                            child: CachedNetworkImage(
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                              imageUrl:
                              widget.url,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),



                        ],
                      )
                  ),
                ),
              ),
              SizedBox(height: 40,),
             // Text(widget.distance+" away",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Text(widget.title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.only(top: 10,left: 50,right: 50),
                child: Text(widget.desc),
              ),
              Spacer(),

              RaisedButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)
                ),
                child: Text("Mark this as taken!!"),
                onPressed: (){
                  taken();

                },
              ),



              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ButtonTheme(
                  minWidth: 300.0,
                  //height: 100.0,
                  child: RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black)
                    ),
                    child: Text("Delete this Feed"),
                    onPressed: (){
                      deleteListing();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedScreen()));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //Center(child: Text(widget.desc),)
    );
  }
}
