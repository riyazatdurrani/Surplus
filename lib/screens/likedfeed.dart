

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surplus/screens/profilepage.dart';
import 'package:surplus/screens/userfeeddescription.dart';

import 'feedScreen.dart';
class LikedFeed extends StatefulWidget {
  String uid;
  LikedFeed(this.uid);
  @override
  _LikedFeedState createState() => _LikedFeedState();
}

class _LikedFeedState extends State<LikedFeed> {
var url=[],title=[],desc=[],feedid=[],likedfeedid=[],a=0;

  getData()  {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('likedFeed');
    collectionReference.doc(widget.uid).collection('likefeed').snapshots().forEach((element) {
       for (int i = 0; i < element.docs.length; i++) {
      //   url.add(element.docs[i].data()['imageurl']);
      //   title.add(element.docs[i].data()['title']);
      //   desc.add(element.docs[i].data()['description']);
      //   feedid.add(element.docs[i].data()['userID']);
      //   print(feedid);
         likedfeedid.add(element.docs[i].data()['userID']);
      }
    });

    // Future.delayed(const Duration(seconds: 3), ()
    // {
    //   setState(() {
    //     a = 1;
    //   });
    // });
  }


getd()async{
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
  var snapshot = await collectionReference.get();
  snapshot.docs.forEach((result) {
    collectionReference
        .doc(result.id)
        .collection('myfeed')
        .snapshots().listen((event) {

if(event.docs.length >0){
//print(event.docs.length);
  for(int i=0;i<event.docs.length;i++){
   //print(event.docs[i].data()['title']);
    for(int j =0;j<likedfeedid.length;j++){
      if(likedfeedid[j] == event.docs[i].id){
          url.add(event.docs[i].data()['imageurl']);
          title.add(event.docs[i].data()['title']);
          desc.add(event.docs[i].data()['description']);
          feedid.add(event.docs[i].data()['userID']);

      }

    }
  }
}

    });
  });

}

@override
  void initState() {

setState(() {
  url=[];title=[];desc=[];feedid=[];likedfeedid=[];
});
  getData();
  Future.delayed(const Duration(seconds: 1), ()
  {
    getd();
  });
Future.delayed(const Duration(seconds:3), () {
  setState(() {
    a=1;
  });
  print(title);
});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return

      a==0?Center(child: CircularProgressIndicator()):
    Container(
      // height: 570,
      child: Scaffold(




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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LikedFeed(widget.uid)));
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.perm_identity),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => profilePage(widget.uid)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),













        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text("YOUR LIKED FEEDS"),
              SizedBox(height: 20,),
              Expanded(
                flex: 4,
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
                                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => userfeeddescription(title[index],url[index],feedid[index],desc[index])));
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
            ],
          ),
        ),
      ),
    );
  }
}
