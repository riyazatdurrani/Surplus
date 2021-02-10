import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:surplus/screens/confirmationPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
var tid;
class UploadData extends StatefulWidget {
  String uid;
  var lat,lon;
  UploadData({this.uid,this.lat,this.lon});

  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  bool showProgress = false;
 File _image;
 final picker = ImagePicker();
var imagename;
var title,description,phoneNumber;

 final _auth= FirebaseAuth.instance;
 User loggedInUser;
 TextEditingController _Titlecontroller =  TextEditingController();
 TextEditingController _Desccontroller =  TextEditingController();
  TextEditingController _phoneNumber =  TextEditingController();
 @override
  void initState() {
   getCurrentUser();
    super.initState();
 }
 void getCurrentUser() async{
   try{
     final user=  await _auth.currentUser;
     if(user != null) {
       setState(() {
         loggedInUser = user;
       });

      // print(loggedInUser.phoneNumber);
     }
   }
   catch(e){
    // print(e);
   }
 }
  @override

  Widget build(BuildContext context) {
    Future getImage() async {
      final pickedFile =  await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 20);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);


        } else {
         // print('No image selected.');
        }

      });
    }
Future UploadImage(BuildContext context) async{
  String filename = basename(_image.path);

  Reference storageReference = FirebaseStorage.instance.ref().child('images').child(widget.uid).child(imagename);
  final UploadTask uploadTask = storageReference.putFile(_image);
  final TaskSnapshot downloadUrl = (await uploadTask);
  final String url = await downloadUrl.ref.getDownloadURL();
 // print(url);
  Map<String,String>feedData={
    'imageurl':url,
    'lat':widget.lat,
    'long':widget.lon,
    'title':title,
    'description':description,
    'phoneNumber':loggedInUser.phoneNumber,
    'userID':loggedInUser.uid,
    'avalibility': '1',
  };

   CrudMethods().uploadFeed(feedData,widget.uid).then((result){
  print(tid.toString() +"          "+ tid.toString() +"Llllllllllllllll");
    setState(() {

    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmationPage(title)));
    Future.delayed(const Duration(seconds: 2), () {
      showProgress = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmationPage(title, tid.toString())),
            (Route<dynamic> route) => false,
      );
    });
  });
  });
    }



    String gettime(){
      DateTime now = DateTime.now();
      var time= now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString();
      var date = new DateTime.now().toString();
      var dateParse = DateTime.parse(date);
      var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
      setState(() {
        imagename=time +"-"+ formattedDate;
      });


    }
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text('Title',style: TextStyle(fontFamily:'Yantramanav',fontWeight: FontWeight.bold),),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),

                    child: TextField(
                     textAlign:TextAlign.center,
                      controller: _Titlecontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,

                      ),
                      onChanged: (v){

                          title=v;

                      },
                    ),
                  ),

SizedBox(height: 35,),
                  Text(' Description',style: TextStyle(fontFamily:'Yantramanav',fontWeight: FontWeight.bold),),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),

                    child: TextField(
                      textAlign:TextAlign.center,
                      controller: _Desccontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,

                      ),
                      onChanged: (v){
                        description=v;
                      },

                    ),


                  ),
                  // SizedBox(height: 25,),
                  // Text(' Whatsapp Contact',style: TextStyle(fontFamily:'Yantramanav',fontWeight: FontWeight.bold),),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[300],
                  //     borderRadius: BorderRadius.circular(15.0),
                  //   ),
                  //
                  //   child: TextField(
                  //     textAlign:TextAlign.center,
                  //     controller: _phoneNumber,
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //
                  //     ),
                  //     onChanged: (v){
                  //       phoneNumber=v;
                  //     },
                  //
                  //   ),
                  //
                  //
                  // ),
SizedBox(height: 25),



                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)
                        ),
                        elevation: 20,
                        child: InkWell(
                          onTap: () {},

                          child: Container(
                            width:MediaQuery.of(context).size.width ,
                            height: 150,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10),),

                              ),
                              // _image == null ? Container() :
                              // CircleAvatar(child: Image.file(_image),radius: 100,),
                               child:_image == null ? IconButton(
                                 iconSize: 50.0,
                                         icon: Icon(Icons.collections),
                                         onPressed: () {

                              },
                                       ) :
                               Image.file(_image, fit:BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 50),
              Center(
                child: Container(
                  // padding: EdgeInsets.fromLTRB(10,2,10,2),
                  width:100,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red)
                  ),
                  child: MaterialButton(
                    onPressed: () async{
                      gettime();
                      getImage();
                    },

                    child: Text(
                        "Photo",style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold )
                    ),
                  ),
                ),
              ),

                  SizedBox(height: 50),

                  Center(
                    child: Text(
                        "all done? please click submit",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold )
                    ),
                  ),


                  SizedBox(height: 50),


                     Center(
                       child: ButtonTheme(
                         minWidth: 300.0,

                         child: RaisedButton(

                           color: Colors.orange,
                           shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),    borderRadius: BorderRadius.circular(18.0),),
                           child: Text('Submit'),
                           onPressed: (){
                             setState(() {
                               showProgress = true;
                             });

                             UploadImage(context);

                          },
                         ),
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
var a;
Map<String,String>feedUpdate={
  'userID':a,
};
class CrudMethods{
  Future<void> uploadFeed(feedData, String uid) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
    collectionReference.doc(uid).collection('myfeed').add(feedData).then((value) {
      a=value.id;
      tid=value.id.toString();
      collectionReference.doc(uid).collection('myfeed').doc(value.id).update(feedUpdate).then((value) => null);
    }

    );


  }
}