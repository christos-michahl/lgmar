import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LG MAR test',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'LG MAR Input test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //text handler
  var input_controller = TextEditingController();
  Response response;

  init_await() async{
   // var x = await post_string("ASda");
    //print(http.Response.fromStream(x) ;
    try{
      //run the post request and store it on response variable
      response = await postRequest("","http://10.0.2.2/lgmar.php");
      print(response);
    }catch(e){
      print(e);
    }


  }

  Future<Response>  postRequest (credentials, url) async {

    Dio dio = new Dio();
    log("credentials on post : $credentials");
    response = await dio.post(
      url,
      data: credentials,
      options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) { return status < 500; }
      ),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,style: TextStyle(fontStyle: FontStyle.italic)),
        actions:  <Widget>[
            new Stack(
              children: <Widget>[
               new IconButton(icon: Icon(Icons.notifications), onPressed: () {

                    }),
              (1 != 0 && 1!=null) ? new Positioned(
              right: 11,
              top: 11,
                child: new Container(
                 padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text('counter',style: TextStyle(color: Colors.white,fontSize: 8,),textAlign: TextAlign.center,),
                ),
              ) : new Container()
              ],
            ),
        ],
      ),
      body: Column(

          children:<Widget>[

            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 90.0,
              child: Image.asset('assets/Capture.PNG'),
            ),
            Container(
              // height:70,

              padding: const EdgeInsets.all(12.0),
              // color: Colors.white,
              child:

              TextField(
                //keyboardType: TextInputType.emailAddress,
                autofocus: false,
                controller: input_controller,
                textAlignVertical: TextAlignVertical.center,
               // onSaved: (String value) {},
                decoration: InputDecoration(
                  hintText:  'Input a text.....',
                  // errorText: 'emptyUsername',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // background
                onPrimary: Colors.white, // foreground
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),

                ),),



              onPressed: () {
              init_await();


              },
              child: Text("submit"),
            ),
          ]
      ),
    );
  }
}
