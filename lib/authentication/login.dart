import 'package:flutter/material.dart';
import 'package:surplus/authentication/register.dart';
import 'package:surplus/models/authmodel.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController =  TextEditingController();
 TextEditingController nameController =  TextEditingController();
 @override
  void initState() {
   nameController = new TextEditingController(text: 'null');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:60,left: 20,right: 20 ),
          child: Column(
            children: [
              Image.asset('assets/images/Group(4).png'),
              SizedBox(height: 40,),
              InputBox(
                Text: "Phone Number (ex: 7051525357)",
                textEditingController: phoneController,
              ),
             // SizedBox(height: 40,),
              // InputBox(
              //   Text: "Password",
              //   textEditingController: passwordController,
              // ),
              SizedBox(height: 40,),

              AuthButton(text: 'Sign In', phoneController: phoneController,nameController: nameController,),
              SizedBox(height: 40,),
       Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: TextStyle(fontWeight: FontWeight.bold),),

                  GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>Register()),
                            (Route<dynamic> route) => false,
                      );
                    },
                      child: Text(" Sign Up",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red ),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
