import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallie/rounded_button.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState() {
    fetchUserData();
    // TODO: implement initState
    super.initState();
  }

  void fetchUserData() async{
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      _user = u;
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        padding: EdgeInsets.only(left: 15,right: 15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                  image: NetworkImage(_user.photoUrl),
                  placeholder: AssetImage('assets/placeholder.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('${_user.displayName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            RoundedButton(
              title: 'Log out',
              color1: Colors.blueGrey,
              color2: Colors.blue[100],
            )
          ],
        ),
      ),
    );
  }
}
