import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var imageLink = 'Generated link: ';
  var isVisible = false;
  var icPicBytes;

  _openGallery() async {
    var picture =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    List imageBytes = await picture.readAsBytes();
    icPicBytes = base64Encode(imageBytes);
    return icPicBytes;
  }

  _uploadImage(picBytes) async {
    var clientID = '2f7307ddc860abf';
    var jsonData = json.encode({'image': picBytes});

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isVisible,
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    imageLink,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    isVisible = false;
                    var picBytes = await _openGalery();
                    imageLink = await _uploadImage(picBytes);
                    setState(() {
                      isVisible = true;
                      print(imageLink);
                    });
                  },
                  child: Text('Upload image'),
                ),
              )
            ],
          )),
    );
  }
}
