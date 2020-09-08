import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class ImageOps extends StatefulWidget {
  @override
  _ImageOpsState createState() => _ImageOpsState();
}

class _ImageOpsState extends State<ImageOps> {
  File _image;

  @override
  Widget build(BuildContext context) {

    Future getImageFromGallery() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }
    Future getImageFromCamera() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Image Uploading...'),
        ),
        body: Builder(
        builder: (context) =>  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.teal,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Center(child: Text("Upload Image Please",style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImageFromCamera();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.mobile,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImageFromGallery();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              Container(
                margin: EdgeInsets.only(left: 40),
                              child: Row(children: <Widget>[
                  RaisedButton(
                      color: Colors.teal,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    SizedBox(width: 40,),
RaisedButton(
                      color: Colors.teal,
                      onPressed: () {
                       uploadPic(context);
                      },
                                       
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                ],),
              )
              
              
            ],
          ),
        ),
        ),
        );
  }
}
