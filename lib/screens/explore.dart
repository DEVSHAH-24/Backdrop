import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallie/config/configuration.dart';
import 'package:wallie/screens/view_wallpaper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final Firestore _db = Firestore.instance;
  final spinKit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
//  List images = [
//    ("https://images.pexels.com/photos/3584345/pexels-photo-3584345.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
//    ("https://images.unsplash.com/photo-1586294839852-650d52bb6923?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"),
//    ("https://images.pexels.com/photos/1742370/pexels-photo-1742370.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
//    ("https://images.pexels.com/photos/355952/pexels-photo-355952.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
//    ("https://images.pexels.com/photos/2740956/pexels-photo-2740956.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
//  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Align(
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Explore',
                  style: TextStyle(color: Colors.blue[100], fontSize: 35),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            StreamBuilder(
                stream: _db
                    .collection('Wallpapers')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                     return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }
}
