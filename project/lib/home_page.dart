import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var picBytes;
  var imgFile;
  var img64;

  // Open gallery and convert image
  _openGallery() async {
    try {
      var imgPicker = ImagePicker();
      var pickedFile = await imgPicker.getImage(source: ImageSource.gallery);

      setState(() {
        imgFile = File(pickedFile.path);
      });

      var bytes = await pickedFile.readAsBytes();
      img64 = base64Encode(bytes);
    } catch (error) {}
  }

  // Upload image
  _uploadImage(img64) async {
    var clientID = ''; // your client id
    var jsonData = json.encode({'image': img64});
    var response = await http.post(
        Uri.parse(
          'https://api.imgur.com/3/image',
        ),
        body: jsonData,
        headers: {
          "Authorization": 'Client-ID $clientID',
          "Content-Type": "application/json"
        });

    var map = json.decode(response.body);
    return map['data']['link'];
  }

  Widget _decideView() {
    if (imgFile == null)
      return Container(
        child: Text('No image'),
        margin: EdgeInsets.only(bottom: 10, top: 70),
      );
    else
      return Container(
        child: Image.file(imgFile),
        width: 300,
        height: 300,
        margin: EdgeInsets.only(bottom: 10, top: 70),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a image'),
        centerTitle: true,
      ),
      body: Container(
          height: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _decideView(),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    await _openGallery();
                    var link = await _uploadImage(img64);
                    print(link);
                  },
                  child: Text('Upload image'),
                ),
              )
            ],
          )),
    );
  }
}
