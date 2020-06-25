import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallie/config/configuration.dart';
import 'package:wallie/screens/view_wallpaper.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  void getUser() async{
   FirebaseUser u =await _auth.currentUser();
    setState(() {
      user = u;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerLeft,
                child: Text('Favorites',textAlign: TextAlign.start,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: primaryColor),))),
       user!=null ? Expanded(
         child: StreamBuilder(
              stream: _db
             .collection("users")
             .document(user.uid)
             .collection("favorites")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                  //  physics: NeverScrollableScrollPhysics(),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    itemCount: snapshot.data.documents.length,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 20,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push((context),
                                MaterialPageRoute(builder: (context) {
                                  return ViewWallpaper(
                                    data: snapshot
                                        .data.documents[index],
                                  );
                                }));
                          },
                          child: Hero(
                              tag: snapshot.data.documents[index].data["url"],
                              child: ClipRRect(borderRadius: BorderRadius.circular(12),child: CachedNetworkImage(imageUrl: snapshot.data.documents[index].data['url']),)
                          ));
                    },
                  );
                }
                return SpinKitDualRing(
                  color: primaryColor,
                  size: 50,
                );

              }),
       ): Text('User not found'),
      ],
    );
  }
}
