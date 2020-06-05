import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewWallpaper extends StatefulWidget {
  final String image;
  ViewWallpaper({this.image});
  @override
  _ViewWallpaperState createState() => _ViewWallpaperState();
}

class _ViewWallpaperState extends State<ViewWallpaper> {
  List images = [
    ("https://images.pexels.com/photos/3584345/pexels-photo-3584345.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.unsplash.com/photo-1586294839852-650d52bb6923?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"),
    ("https://images.pexels.com/photos/1742370/pexels-photo-1742370.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.pexels.com/photos/355952/pexels-photo-355952.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    ("https://images.pexels.com/photos/2740956/pexels-photo-2740956.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: widget.image,
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Image.asset('assets/placeholder.jpg'),
              imageUrl: widget.image,
            ),
          ),
        ),
      ),
    );
  }
}
