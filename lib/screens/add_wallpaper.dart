import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AddWallpaper extends StatefulWidget {
  @override
  _AddWallpaperState createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  File _image;
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  List<ImageLabel> detectedLabels;

  @override
  void dispose() {
    labeler.close(); //thus terminating the labeler after it is used.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload a wallpaper'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _loadImage();
                  },
                  child: _image != null
                      ? Image.file(_image)
                      : Image.asset('assets/placeholder.jpg'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Click on image to upload wallpaper'),
                SizedBox(
                  height: 20,
                ),
                detectedLabels != null
                    ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 12,
                          children: detectedLabels.map((label) {
                            return Chip(
                              
                              label: Text(label.text),
                            );
                          }).toList(),
                        ),
                    )
                    : Container(),
              ],
            ),
          ),
        ));
  }

  void _loadImage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery);
    final FirebaseVisionImage visionImage =
         FirebaseVisionImage.fromFile(_image);

    List<ImageLabel> labels = await labeler.processImage(visionImage);

    setState(() {
      detectedLabels = labels;
      _image = File(image.path);
    });
    
  }
}
//    for(var label in labels){
//      print("${label.text} [${label.confidence}]");
//    }
