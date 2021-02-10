import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surplus/screens/feedScreen.dart';



class OTPScreen extends StatefulWidget {
  final String phone,name;
  OTPScreen(this.phone,this.name);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;

  final TextEditingController _pinPutController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );


  nextPage(String uid) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool visitedFlag = await getVIsitingFlag();
    setVIsitingFlag();
    preferences.setString('uid', uid);
    if (visitedFlag == true) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FeedScreen()));
    }
    else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FeedScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'Verify +91-${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              // onSubmit: (String pin) => _showSnackBar(pin),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      if(widget.name.toString()!='null'){
                        nextPage(value.user.uid);
                        CollectionReference collectionReference = FirebaseFirestore.instance.collection('Feed');
                        Map<String,String>name={
                          'name':widget.name.toString(),
                        };
                        collectionReference.doc(value.user.uid).set(name);
                      }
                     else{
                       print("good!!");
                      }


                      nextPage(value.user.uid);
                      //
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => FeedScreen()),
                      //     (route) => false);
                      print('pass to home');
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      // ignore: deprecated_member_use
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }


  _verifyphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              //print(value.user.phoneNumber);

              nextPage(value.user.uid);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedScreen(),
                  ),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));

  }

  @override
  void initState() {
    super.initState();

    _verifyphone();
  }
}

getVIsitingFlag() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false ;
  return alreadyVisited;
}

setVIsitingFlag()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('alreadyVisited', true);
}