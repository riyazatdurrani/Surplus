import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class FeedDescription extends StatefulWidget {
  var url,title,distance,desc,phoneNumber;
  FeedDescription(this.url,this.title,this.distance,this.desc,this.phoneNumber);

  @override
  _FeedDescriptionState createState() => _FeedDescriptionState();
}

class _FeedDescriptionState extends State<FeedDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(widget.distance+" away",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Text(widget.title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.only(top: 10,left: 50,right: 50),
                child: Text(widget.desc),
              ),
              Spacer(),
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
                    child: Text("Connect"),
                    onPressed: (){
                      FlutterOpenWhatsapp.sendSingleMessage(widget.phoneNumber, "Hello i saw your post \"${widget.title}\" on surplus app!! is it still available?");
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
