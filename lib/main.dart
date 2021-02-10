import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surplus/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:surplus/authentication/register.dart';
import 'package:surplus/screens/feedScreen.dart';
import 'package:surplus/screens/loginscreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override


  Future<void> rememberMe() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uidd = preferences.getString('uid');
     Navigator.push(context,
        MaterialPageRoute(builder: (context) => uidd==null ?
        Register() :FeedScreen()),
      );
 }



void initState() {
super.initState();
 rememberMe();
 }

  @override
  Widget build(BuildContext context) {
    return(Container());
  }
}