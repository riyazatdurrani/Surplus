import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:surplus/screens/feedDescription.dart';
class CardModel extends StatefulWidget {
String url,title,distance,desc,phoneNumber,userID,likecount;
CardModel({this.title,this.url,this.distance, this.desc,this.userID,this.likecount,this.phoneNumber});

  @override
  _CardModelState createState() => _CardModelState();
}

class _CardModelState extends State<CardModel> {
  @override
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.phoneNumber);

      }
    } catch (e) {
      print(e);
    }
  }
  void initState() {
    print(widget.likecount);
    getCurrentUser();
    super.initState();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    var temp;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('likedFeed');
    Map<String,String>dummy={
      'Dummy':"dummy",
    };
    Map<String,String>like={
      'userID':widget.userID,
    };
    print(!isLiked);
   print(widget.userID);
   if(!isLiked==true) {
     collectionReference.doc(loggedInUser.uid).set(dummy);
     collectionReference.doc(loggedInUser.uid).collection('likefeed')
         .add(like)
         .then((value) => print("added"));
   }
   else{
     print("X");

    // var snapshot = await collectionReference.get();
     collectionReference.doc(loggedInUser.uid).collection('likefeed').snapshots().forEach((element) {
       for (int i = 0; i < element.size; i++) {
         print(element.docs[i].id);
         print(element.docs[i].data()['userID']);
         if (element.docs[i].data()['userID'].toString() ==
             widget.userID.toString()) {
           collectionReference.doc(loggedInUser.uid).collection('likefeed').doc(
               element.docs[i].id).delete();
         }
       }
     });
//  snapshot.docs.forEach((result) {
//        collectionReference
//            .doc(result.id)
//            .collection('likefeed')
//            .snapshots().forEach((element) {
//          for (int i = 0; i < element.size; i++) {
//            print(element.docs[i].id);
//            print(element.docs[i].data()['userID']);
// if(element.docs[i].data()['userID'].toString() ==widget.userID.toString()){
//   collectionReference.doc(loggedInUser.uid).collection('likefeed').doc(element.docs[i].id).delete();
// }
//          }
//        });
//      });


   }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          elevation: 20,
          child: InkWell(
            onTap: () {
              print(widget.userID);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedDescription(widget.url,widget.title,widget.distance,widget.desc,widget.phoneNumber)));
             },

            child: Container(
              width:MediaQuery.of(context).size.width ,
              height: 300,
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 10,),
                      Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(flex: 5, child: Text(widget.distance,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),)),
                          Expanded(flex:1,child: IconTheme( data: new IconThemeData(
                              color: Colors.orange),  child: Icon(Icons.add)),),
                          Expanded(flex:1,child: IconTheme( data: new IconThemeData(
                              color: Colors.orange),  child: LikeButton(onTap:onLikeButtonTapped,isLiked: widget.likecount==1.toString()?true:false,),
                          ),
                          ),
                        ],
                      ),


                    ],
                  )
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}


