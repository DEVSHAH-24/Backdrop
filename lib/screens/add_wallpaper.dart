import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AddWallpaper extends StatefulWidget {
  @override
  _AddWallpaperState createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  bool _uploading = false;
  bool _isUploaded = false;
  File _image;
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  List<ImageLabel> detectedLabels;
  List<String> labelsInString = [];
  Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
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
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _loadImage();
                    },
                    child: _image != null
                        ? Image.file(_image)
                        : Image.asset('assets/placeholder.jpg'),
                  ),
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
                SizedBox(height: 40),
               _uploading ? Text('Uploading wallpaper') : Text('.'),
                _isUploaded ? Text('Upload completed') : Text('.'),
                SizedBox(
                  height: 40,
                ),
                RaisedButton(
                  onPressed: () => _uploadWallpaper(),
                  child: Text('Upload'),
                ),
              ],
            ),
          ),
        ));
  }

  void _loadImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    List labelsInString;


    setState(() {
       detectedLabels = labels;
      _image = image;
    });
    for (ImageLabel l in labels) {
      labelsInString.add(l.text);
    }
  }

  void _uploadWallpaper() async {
    if (_image != null) {
      String fileName = path.basename(_image.path);
      print(fileName);

      FirebaseUser user = await _auth.currentUser();
      String uid = user.uid;
      StorageUploadTask task = _storage
          .ref()
          .child('Wallpapers')
          .child(uid)
          .child(fileName)
          .putFile(_image);
      task.events.listen((e) {
        if (e.type == StorageTaskEventType.progress) {
          setState(() {
            _uploading = true;
          });
        }
        if (e.type == StorageTaskEventType.success) {
           e.snapshot.ref.getDownloadURL().then((url) {
           _db.collection('Wallpapers').add({
             "url": url,
             "date": DateTime.now(),
             "uploaded_by": uid,
             "tags": labelsInString.toList(),
           }
           );
           Navigator.pop(context);

          });
          setState(() {
            _uploading = false;
            _isUploaded = true;
          });
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text('ERROR'),
              content: Text("Select image to upload"),
              actions: <Widget>[
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(ctx),
                )
              ],
            );
          });
    }
  }
}
//    for(var label in labels){
//      print("${label.text} [${label.confidence}]");
//    }
