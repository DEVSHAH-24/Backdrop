import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallie/config/configuration.dart';
import 'package:wallie/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallie/screens/add_wallpaper.dart';
import 'package:wallie/screens/view_wallpaper.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Firestore _db = Firestore.instance;

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
              gradient: LinearGradient(
                  colors: [Colors.grey, Colors.white12, Colors.black12])),
          padding: EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: _user != null
              ? Stack(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("My uploaded wallpapers"),
                          IconButton(
                            icon: Icon(Icons.add_to_photos),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWallpaper(),
                                    fullscreenDialog: true),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: _db
                            .collection('Wallpapers')
                            .where('uploaded_by', isEqualTo: _user.uid)
                            .orderBy("date", descending: true)
                            .snapshots(),
                        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              staggeredTileBuilder: (int index) =>
                                  StaggeredTile.fit(1),
                              itemCount: snapshot.data.documents.length,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 20,
                              padding: EdgeInsets.all(15),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      (context),
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ViewWallpaper(
                                            image: snapshot.data
                                                .documents[index].data["url"],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: snapshot
                                        .data.documents[index].data["url"],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot.data
                                              .documents[index].data['url'],
                                              ),
                                    ),
                                  ),
                  
                                );
                              },
                            );
                          }
                          return SpinKitDualRing(
                            color: primaryColor,
                            size: 50,
                          );
                        }),
                  ],
                )
              : LinearProgressIndicator(
                  backgroundColor: Colors.blue[200],
                )),
    );
  }
}
//Image(image: CacheImage(images[index])));
/* StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemCount: images.length,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewWallpaper(image: images[index])));
                          },
                          child: Hero(
                            tag: images[index],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Image.asset('assets/placeholder.jpg'),
                                imageUrl: images[index],
                              ),
                            ),
                          ),
                        );
                      },
                    )*/
