import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AddWallpaper extends StatefulWidget {
  @override
  _AddWallpaperState createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a wallpaper'),
        
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: (){},
                child: Image.asset('assets/placeholder.jpg'),

              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Click on image to upload wallpaper'
              )
            ],
          ),
        ),
      ),
    );
  }
  void _loadImage() async{
    var image = ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
}
