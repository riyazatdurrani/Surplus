//import 'dart:html';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surplus/authentication/login.dart';
import 'package:surplus/screens/userfeeddescription.dart';
import 'package:image_picker/image_picker.dart';

import 'feedScreen.dart';
import 'likedfeed.dart';

class profilePage extends StatefulWidget {
  String uid;
  profilePage(this.uid);
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {

var a=0;
var url=[],title=[],desc=[],feedid=[];
 getData() {
   CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
   collectionReference.doc(widget.uid).collection('myfeed').snapshots().forEach((element) {
     for (int i = 0; i < element.docs.length; i++) {
       url.add(element.docs[i].data()['imageurl']);
       title.add(element.docs[i].data()['title']);
      desc.add(element.docs[i].data()['description']);
       feedid.add(element.docs[i].data()['userID']);
       print(feedid);
     }
   });
   Future.delayed(const Duration(seconds: 2), ()
   {
     setState(() {
       a = 1;
     });
   });
 }
File _image;
final picker = ImagePicker();
var imagename;
var dpName="";
  @override
  void initState() {

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
    collectionReference.doc(widget.uid).snapshots()
        .listen((event) {
if(event.data()['dp'] != null) {
  dpName = event.data()['dp'];
}
else{
  print("hahahah");
}
    });

      Future.delayed(const Duration(seconds: 1), () {
      getData();

    });
    super.initState();
  }





Future UploadImage(BuildContext context) async{


  Reference storageReference = FirebaseStorage.instance.ref().child('DisplayPics').child(widget.uid).child("dp");
  final UploadTask uploadTask = storageReference.putFile(_image);
  final TaskSnapshot downloadUrl = (await uploadTask);
  final String url = await downloadUrl.ref.getDownloadURL();
  print(url);
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
  Map<String,String>dp={
    'dp':url.toString(),
  };
  collectionReference.doc(widget.uid).update(dp);
 setState(() {
   dpName =url.toString();
 });
}


  @override
  Widget build(BuildContext context) {

    Future getImage([BuildContext context]) async {
      final pickedFile =  await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 20);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(_image);
          UploadImage(context);

        } else {
          print('No image selected.');
        }

      });
    }








    return a==0?Scaffold(body: Center(child: CircularProgressIndicator())): Scaffold(


appBar: AppBar(
  //title: Text('My App'),
  actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.power_settings_new,
        color: Colors.white,
      ),
      onPressed: () async{

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('uid');
        FirebaseAuth _auth = FirebaseAuth.instance;
        _auth.signOut().then((value) =>
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => Login()),

            ),


        );
      },
    )
  ],
),


      resizeToAvoidBottomInset: false,
    //  floatingActionButtonLocation:
     // FloatingActionButtonLocation.centerDocked,
    //  floatingActionButton: Container(
      //  width: 80,
        //child: FloatingActionButton(
          // backgroundColor: Colors.orange,
          // shape: RoundedRectangleBorder(
          //     borderRadius: new BorderRadius.circular(30)),
          // child: const Icon(Icons.add),
          // onPressed: () {
          //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadData(
          //   //     uid: loggedInUser.uid,
          //   //     lat: latitude,
          //   //     lon: longitude)));
          //
          // },
        //),
     // ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () async{

                     Navigator.pushAndRemoveUntil(
                         context,
                        MaterialPageRoute(builder: (context) => FeedScreen()),
                         (route) => false);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                   // FocusScope.of(context).requestFocus(myFocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LikedFeed(widget.uid)));
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.perm_identity),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => profilePage(widget.uid)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),















      body: SafeArea(

        child:  Column(

          children: [
            SizedBox(height: 20,),

            Expanded(
              flex: 1,
              child: Container(
                width: 200,
                height:200,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(child: Icon(Icons.camera_alt_sharp),
    onTap: () {
      getImage(context);
      print("hello");
    }
    ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      child: ClipOval(
                        child: Image.network(
                       dpName==""?   'https://cutt.ly/7jS7o1c': dpName.toString(),
                          // width: 100,
                          // height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),



SizedBox(height: 30,),
            Expanded(
              flex: 3,
              child: Container(
               // height: 570,
                child: ListView.builder(
                    itemCount: title.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child:
                        Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 20,
                              child: InkWell(
                                onTap: () {
                                  print(widget.uid);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => userfeeddescription(title[index],url[index],feedid[index],desc[index])));
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
                                              url[index],
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(title[index],style: TextStyle(fontWeight: FontWeight.bold),),
                                          SizedBox(height: 10,),




                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }


}









