import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:developer';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  int counter = 0;
  bool _progressBar_active = false;
  var input_controller = TextEditingController();
  Response response;

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MyApp();
    }));
  }

  @override
  void initState() {
    super.initState();


    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android:  initializationSettingsAndroid,iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);


  }
  //text handler


  init_await(text) async{
   // var x = await post_string("ASda");
    //print(http.Response.fromStream(x) ;
    try{
      //run the post request and store it on response variable
      response = await postRequest(text,"http://10.0.2.2/lgmar.php");
      setState(() {
        _progressBar_active= false;
      });
      if(response.data != null){
        Map<String, dynamic> api_response = jsonDecode(response.data);

        if(api_response["res"]["status"] == "success"){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("The string you submitted has ${ api_response["res"]["data"]} characters"),
            //     backgroundColor: Colors.greenAccent,
          ));
          showNotificationMediaStyle(context, api_response["res"]["data"]);
          setState(() {
            counter++;
          });
        }
        else{

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("The string was not submitted correctly"),
            //     backgroundColor: Colors.greenAccent,
          ));
        }

        print(response);
      }
    }catch(e){
      print(e);
    }


  }

  Future<Response>  postRequest (text, url) async {

    Dio dio = new Dio();
    log("credentials on post : $text");
    response = await dio.post(
      url,
      data: text,
      options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) { return status < 500; }
      ),
    );
    return response;
  }
  Widget _progressBar(){
    return LinearProgressIndicator(backgroundColor: Colors.white);
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
                 setState(() {
                   counter = 0;
                 });

               }),
              (counter > 0 && counter!=null) ? new Positioned(
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
                  child: Text("$counter",style: TextStyle(color: Colors.white,fontSize: 8,),textAlign: TextAlign.center,),
                ),
              ) : new Container()
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child:
         Column(

          children:<Widget>[
            _progressBar_active ? _progressBar(): SizedBox.shrink(),
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
                maxLength: 50,
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
                var text = {"input_text":input_controller.text};
                setState(() {
                  _progressBar_active= true;
                });
                init_await(text);


              },
              child: Text("submit"),
            ),
          ]
      ),
    ),);
  }
}
Future<void> showNotificationMediaStyle(context,counter) async {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'media channel id',
    'media channel name',
    'media channel description',
    color: Colors.greenAccent,
    enableLights: true,
    largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
    styleInformation: MediaStyleInformation(),
  );
  var platformChannelSpecifics =
  NotificationDetails(android:androidPlatformChannelSpecifics,iOS: null);
  await flutterLocalNotificationsPlugin.show(
      0, "", 'Text has $counter characters', platformChannelSpecifics);
}

