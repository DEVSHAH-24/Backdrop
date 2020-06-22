import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallie/rounded_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallie/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black,Colors.transparent],
             begin: Alignment.topCenter,
            end: Alignment.center,
          ),
            image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        )),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
              ),

              Expanded(
                child: Hero(
                  tag: 'logo',
                  child: Image(
                    fit: BoxFit.fitHeight,
                    color: Colors.black,
                    alignment: Alignment.center,
                    image: AssetImage(
                      "assets/backdroplogo11.png",
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
                width: 25,
              )
              ,
              Expanded(
                child: TypewriterAnimatedTextKit(
                  isRepeatingAnimation: false,
                  text: ['Backdrop'],
                  speed: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  textStyle: TextStyle(

                    color: Colors.black ,

                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Expanded( 
                child: SizedBox(
                  height: 225,
                ),
              ),
//
              RoundedButton(
                onPressed: () {
                  _signInWithGoogle();
                },
                title: 'Sign In with Google',
                color1: Colors.black,
                color2: Colors.tealAccent,
              ),
              SizedBox(
                height: 45,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {

    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("Signed in " + user.displayName);
      _db.collection("users").document(user.uid).setData({
        "displayName": user.displayName,
        "email": user.email,
        "uid": user.uid,
        "photoUrl": user.photoUrl,
        "lastSignIn": DateTime.now(),

      }
      ,merge: true );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
    }
    catch(e){
    print(e.message);

    }





  }
}

//Container(
//           //   padding: EdgeInsets.only(left: 20, right: 20),
//              width: MediaQuery.of(context).size.width,
//              //height: MediaQuery.of(context).size.height,
//              decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                colors: [Colors.black, Color(0x00000000)],
//                begin: Alignment.bottomCenter,
//                end: Alignment.center,
//              )),
//            ),
