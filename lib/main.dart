import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wallie/screens/home_page.dart';
import 'package:wallie/screens/login_screen.dart';
import 'config/configuration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backdrop',
      theme: ThemeData(
        fontFamily: "productsans",
        brightness: Brightness.dark,
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map <String, dynamic> message) async {
        print("onMessage: $message");
        String title = message["notification"]["title"] ?? "";
        String body = message["notification"]["body"] ?? "";
        print(title);
        print(body);
        displayDialog(
          title: title,
          body: body,
        );
      },
      onLaunch: (Map <String, dynamic> message) async {
        print("onMessage: $message");
        String title = message["notification"]["title"] ?? "";
        String body = message["notification"]["body"] ?? "";
        print(title);
        print(body);
        displayDialog(
          title: title,
          body: body,
        );
      },
      onResume: (Map <String, dynamic> message) async {
        print("onMessage: $message");
        String title = message["notification"]["title"] ?? "";
        String body = message["notification"]["body"] ?? "";
        print(title);
        print(body);
        displayDialog(
          title: title,
          body: body,
        );
      },
    );
    _firebaseMessaging.subscribeToTopic("promotion");

    super.initState();
  }

  Future displayDialog({String title, String body}) {
    return showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          FlatButton(
            child: Text('Dismiss'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          if (user != null) {
            return HomePage();
          } else {
            return LoginScreen();
          }
        }
        return LoginScreen();
      },
    );
  }

}