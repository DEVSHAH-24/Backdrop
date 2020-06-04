import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallie/rounded_button.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List images = [
    ("https://images.pexels.com/photos/3584345/pexels-photo-3584345.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.unsplash.com/photo-1586294839852-650d52bb6923?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"),
    ("https://images.pexels.com/photos/1742370/pexels-photo-1742370.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.pexels.com/photos/355952/pexels-photo-355952.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.pexels.com/photos/2740956/pexels-photo-2740956.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState() {
    fetchUserData();

    super.initState();
  }

  void fetchUserData() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      _user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white30,Colors.white12,Colors.black12])),
        padding: EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                image: NetworkImage(_user.photoUrl),
                placeholder: AssetImage('assets/placeholder.jpg'),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '${_user.displayName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              onPressed: () {
                _auth.signOut();
              },
              title: 'Log out',
              color1: Colors.blueGrey,
              color2: Colors.blue[100],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("My uploaded wallpapers"),
                  IconButton(
                    icon: Icon(Icons.add_to_photos),
                    onPressed: (){},
                  )
                ],
              ),
            ),
            StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemCount: images.length,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image(image: CacheImage(images[index])));
              },
            )
          ],
        ),
      ),
    );
  }
}
