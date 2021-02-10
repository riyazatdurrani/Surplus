import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surplus/models/cardmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surplus/screens/profilepage.dart';
import 'package:surplus/screens/likedfeed.dart';
import 'uploadData.dart';
import 'package:geolocation/geolocation.dart';

var latarr = [],
    longarr = [],
    titlearr = [],
    descarr = [],
    urlarr = [],
    km = [],
phoneNumber=[],
userID=[],
likedarray=[],
likecount=[],
    b = 0;
double a = 0.0;

class FeedScreen extends StatefulWidget {
  FeedScreen();
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  Animation<Offset> animation;
  AnimationController animationController;
  Animation<Offset> animation1;

  final _auth = FirebaseAuth.instance;

  User loggedInUser;
  String latitude = '00.00000';
  String longitude = '00.00000';

  @override
  void getdata(
    id,
    longitude,
    latitude,
  ) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Feed');

    var snapshot = await collectionReference.get();
    snapshot.docs.forEach((result) {

      result.id !=loggedInUser.uid ?


      collectionReference
          .doc(result.id)
          .collection('myfeed')
          .snapshots()
          .listen((event) {
            print("khadooooooooooooos");
            print(event.docs);
            print("khadooooooooooooos");

        for (int i = 0; i < event.docs.length; i++) {

              if(event.docs[i].data()['avalibility'] == "1") {
                likedarray.contains(event.docs[i].data()['userID']) ? likecount
                    .add(1) : likecount.add(0);
                userID.add(event.docs[i].data()['userID']);
                urlarr.add(event.docs[i].data()['imageurl']);
                latarr.add(event.docs[i].data()['lat']);
                longarr.add(event.docs[i].data()['long']);
                titlearr.add(event.docs[i].data()['title']);
                descarr.add(event.docs[i].data()['description']);
                phoneNumber.add(event.docs[i].data()['phoneNumber']);

              }
              else{
               // print("oops");
              }
        }
        //print(likecount);
      })

          : print("hello") ;
    });

    Future.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < titlearr.length; i++) {
        //print(latarr[i] + "kkk" + longarr[i]);
       // print(latitude + "lllll" + longitude);
        km.add(distance(double.parse(latitude), double.parse(longitude),
            double.parse(latarr[i]), double.parse(longarr[i]), 'K'));
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {

        b = 1;
      });
    });
  }

  String distance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'K') {
      dist = dist * 1.609344;
    } else if (unit == 'N') {
      dist = dist * 0.8684;
    }
    return dist.toStringAsFixed(2);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }





  loadData() {
    getCurrentUser();

    getCurrentLocation();
    Future.delayed(const Duration(seconds: 4), () {
      getlikedarray();
      getdata(loggedInUser, longitude, latitude);
    });
  }
  var titlearr1= [];
  var descarr1=[];
  var urlarr1= [];
  var km1= [];
  var phoneNumber1=[];
  var userID1 = [];
  var likecount1 =[];










  getlikedarray()async{
  CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('likedFeed');
  collectionReference.doc(loggedInUser.uid).collection('likefeed').snapshots().listen((event) {
    if(event.docs ==[]) {
      likedarray.add(0);
    }
  else {
      for (int i = 0; i < event.docs.length; i++) {
       // print(event.docs[i].data()['userID']);
        likedarray.add(event.docs[i].data()['userID']);
      }
    }
  });


    }


  void initState() {
    myFocusNode = FocusNode();



    latarr = [];
    longarr = [];
    titlearr = [];
    descarr = [];
    urlarr = [];
    userID = [];
    km = [];
    phoneNumber = [];
    likecount = [];


    loadData();
    titlearr1 = titlearr;
    descarr1 = descarr;
    urlarr1 = urlarr;
    km1 = km;
    userID1 = userID;
    phoneNumber = phoneNumber1;
    likecount1 = likecount;


    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        a = 1.0;

      });
    });

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(begin: Offset.zero, end: Offset(0, -0.3))
        .animate(animationController);
    animationController.forward();

    animation1 = Tween<Offset>(begin: Offset.zero, end: Offset(0, -3))
        .animate(animationController);
    animationController.forward();
  }



  getCurrentLocation() async {
    Geolocation.enableLocationServices().then((result) {}).catchError((e) {});
    Geolocation.currentLocation(accuracy: LocationAccuracy.best)
        .listen((result) {
      if (result.isSuccessful) {
        setState(() {
          latitude = result.location.latitude.toString();
          longitude = result.location.longitude.toString();
        });
      }
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

      }
    } catch (e) {
     // print(e);
    }
  }

  onItemChanged(String value) {
    var searchedTitlearr;
    var titleindexnmbr = [],updatedtittlearr = [],updatedDescarr = [], updatedKmarr = [],updatedUrlarr = [],updatedphonenumber=[],updateduserID=[],updatedlikecount=[];
    searchedTitlearr = titlearr
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    for (int i = 0; i < titlearr.length; i++) {
      for (int j = 0; j < searchedTitlearr.length; j++) {
        if (searchedTitlearr[j].toString() == titlearr[i].toString()) {
          titleindexnmbr.add(i);
         // print("k$titleindexnmbr");
        }
      }
    }
    for(int i=0;i<titleindexnmbr.length;i++){
      updatedtittlearr.add(titlearr[titleindexnmbr[i]]);
      updatedDescarr.add(descarr[titleindexnmbr[i]]);
      updatedKmarr.add(km[titleindexnmbr[i]]);
      updatedUrlarr.add(urlarr[titleindexnmbr[i]]);
      updatedphonenumber.add(phoneNumber[titleindexnmbr[i]]);
      updateduserID.add(userID[titleindexnmbr[i]]);
      updatedlikecount.add(likecount[titleindexnmbr[i]]);
            }



    setState(() {
      titlearr1=updatedtittlearr;
      urlarr1=updatedUrlarr;
      descarr1=updatedDescarr;
      km1= updatedKmarr;
      phoneNumber1=updatedphonenumber;
      userID1=updateduserID;
      likecount1=updatedlikecount;
    });


  }
  FocusNode myFocusNode;
  @override
  void dispose() {

    myFocusNode.dispose();

    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    return b == 0
        ? Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: animation,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: ScreenHeight - ScreenHeight / 1.6),
                  Spacer(),
                  Align(
                    child: SlideTransition(
                      position: animation1,
                      child: Transform.scale(
                        scale: 1.5,
                        child: AnimatedOpacity(
                            duration: Duration(seconds: 1),
                            opacity: a,
                            child: Image.asset('assets/images/Group(4).png')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        :
    Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              width: 80,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30)),
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadData(
                                uid: loggedInUser.uid,
                                lat: latitude,
                                lon: longitude)));

                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () async{

                          //     SharedPreferences preferences = await SharedPreferences.getInstance();
                          //     preferences.remove('uid');
                          //     FirebaseAuth _auth = FirebaseAuth.instance;
                          //      _auth.signOut().then((value) =>
                          //         Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) => Login()),
                          //
                          //     ),
                          //
                          //
                          // );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 14,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(myFocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 12,
                      child: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LikedFeed(loggedInUser.uid)));
                        },
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: IconButton(
                        icon: Icon(Icons.perm_identity),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => profilePage(loggedInUser.uid)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                // color: Colors.blue,
                height: 800,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(
                              Radius.circular(70),
                            )),
                        child: Container(
                          child: TextField(
                            focusNode: myFocusNode,
                            controller: searchController,
                            onChanged: onItemChanged,
                           //showSearch(context: context,delegate:DataSearch(titlearr,descarr,km,urlarr));


                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,),
                              border: InputBorder.none,
                              hintText: 'Search for blessings',
                              hintStyle: TextStyle(color: Colors.grey),

                            ),
                          ),
                        ),
                      ),

                      // SizedBox(height: 30,),

// child:

                      //
                      // CardModel(url:'https://cutt.ly/RjqGNW9',title:'Tasty chicken curry',distance:"2.5 kms, Kormangala"),
                      // CardModel(url:'https://cutt.ly/hjqLcG3',title:'Semi-woolen shirt',distance:"4 kms, BTM layout"),
                      // CardModel(url:'https://cutt.ly/IjqLET0',title:'Type-C data cable',distance:"7 kms, Shanti nagar"),
                      // CardModel(url:'https://cutt.ly/qjqLITM',title:'Biryani for two people',distance:"5 kms, SP Road"),
                      // CardModel(url:'https://cutt.ly/HjqLA9w',title:'Old books for giving away',distance:"1 km, Indiranagar"),
                      // CardModel(url:'https://cutt.ly/sjqLHOp',title:'Vintage fan ',distance:"10 kms, K R Puram"),
                      //  CardModel(url:'https://cutt.ly/jjqLNdi',title:'baby cradle',distance:"4 kms, MG Road"),
                      //CardModel(url:'https://cutt.ly/5jqLsOx',title:'Old helmet',distance:"1.5 kms, Hsr Layout"),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height -200,
                          child: ListView.builder(
                              itemCount: titlearr1.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: CardModel(
                                      url: urlarr1[index],
                                      title: titlearr1[index].toString(),
                                      distance: "${km1[index]} kms",
                                      desc: descarr1[index].toString(),
                                    userID:userID1[index].toString(),
                                   likecount:likecount1[index].toString(),
                                    phoneNumber:phoneNumber1[index].toString()),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

