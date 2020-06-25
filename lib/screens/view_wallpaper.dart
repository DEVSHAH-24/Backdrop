import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';
import 'package:wallie/config/configuration.dart';

class ViewWallpaper extends StatefulWidget {
  final DocumentSnapshot data;
  ViewWallpaper({this.data});
  @override
  _ViewWallpaperState createState() => _ViewWallpaperState();
}

class _ViewWallpaperState extends State<ViewWallpaper> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Icon favIcon = Icon(Icons.favorite_border);
  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.data["tags"].toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: widget.data['url'],
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        Image.asset('assets/placeholder.jpg'),
                    imageUrl: widget.data['url'],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                    );
                  }).toList(),
                ),
              ),
              Container(
                  child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  RaisedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Get Wallpaper'),
                    onPressed: launchURL,
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                    onPressed: createDynamicLink,
                  ),
                  RaisedButton.icon(
                    icon: favIcon,
                    label: Text(""),
                    onPressed: addToFavorite,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  void launchURL() async {
    try {
      await launch(widget.data["url"],
          option: CustomTabsOption(
            animation: CustomTabsAnimation.fade(),
            toolbarColor: primaryColor,
          ));
    } catch (e) {}
  }

  void addToFavorite() async {
    setState(() {
      favIcon = Icon(
        Icons.favorite,
        color: Colors.red,
      );
    });

    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid;
    return _db
        .collection("users")
        .document(uid)
        .collection("favorites")
        .document(widget.data.documentID)
        .setData(
          widget.data.data,
        );
  }

  void createDynamicLink() async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      link: Uri.parse(widget.data.documentID),
      uriPrefix: "https://ds24.page.link",
      androidParameters: AndroidParameters(
        packageName: 'com.ds24.wallie',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        minimumVersion: "0",
        bundleId: 'com.ds24.wallie',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: "WallyApp",
          description: "Explore the finesse of wallpapers",
          imageUrl: Uri.parse(widget.data['url'])),
    );

    Uri uri = await dynamicLinkParameters.buildUrl();
    String url = uri.toString();
    print(url);
    Share.share(url);
  }
}
