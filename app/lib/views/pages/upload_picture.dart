import 'dart:convert';

import 'package:app/models/face_shape.dart';
import 'package:app/models/picture.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/pictures.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPicture extends StatefulWidget {
  static final String routeName = '/uploadPicture';
  static const String defaultImageUrl = 'assets/icons/image_placeholder.png';
  final OnPictureUploaded onPictureUploaded;

  const UploadPicture({Key key, @required this.onPictureUploaded})
      : super(key: key);

  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  bool _imagePicked;
  String _imageUrl = UploadPicture.defaultImageUrl;
  File _image;
  bool _isUploading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  OnPictureUploaded _onPictureUploaded;

  @override
  void initState() {
    super.initState();
    _imagePicked = false;
    _onPictureUploaded = widget.onPictureUploaded;
  }

  Future<void> getImageFromCamera() async {
    final pickedImg = await picker.getImage(source: ImageSource.camera);

    setState(() {
      /// This null check avoids crashes if the user taps the "back" button when they are choosing an image
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        _imagePicked = true;
      }
    });
  }

  Future<void> getImageFromGallery() async {
    final pickedImg = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      /// This null check avoids crashes if the user taps the "back" button when they are choosing an image
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        _imagePicked = true;
      }
    });
  }

  Future<void> _uploadPicture() async {
    setState(() {
      _isUploading = true;
    });
    if (_imagePicked && _image != null) {
      final response = await PicturesService.upload(picture: _image);
      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        final rawAPIResponse = await response.stream.bytesToString();
        if (rawAPIResponse != null && rawAPIResponse.isNotEmpty) {
          final parsedAPIResponse = jsonDecode(rawAPIResponse);
          final Picture pictureUploaded =
              Picture.fromJson(parsedAPIResponse['picture']);

          final FaceShape faceShape =
              FaceShape(shapeName: parsedAPIResponse['face_shape']);

          _onPictureUploaded(
              newPicture: pictureUploaded,
              pictureFile: _image,
              newFaceShape: faceShape);

          Navigator.pop(_scaffoldKey.currentContext);
        }
      } else {
        NotificationService.notify(
            scaffoldKey: _scaffoldKey,
            message: 'Upload failed. Please try another picture.');
      }
    }
    setState(() {
      _isUploading = false;
    });
  }

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Upload your picture',
            style: TextStyle(fontFamily: 'Klavika'),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 50.0),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                SvgPicture.asset('assets/icons/upload_your_picture_top.svg',
                    semanticsLabel: 'Upload your picture'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text(
                  'Upload your picture',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                ActionButton(
                    text: 'Choose from your gallery',
                    icon: Icon(Icons.photo_library),
                    action: getImageFromGallery,
                    colour: Color.fromARGB(255, 38, 166, 154)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                ActionButton(
                    text: 'Take a picture',
                    icon: Icon(Icons.photo_camera),
                    action: getImageFromCamera,
                    colour: Color.fromARGB(255, 124, 62, 233)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                _image == null ? Image.asset(_imageUrl) : Image.file(_image),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                _isUploading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ActionButton(
                        text: 'Upload',
                        icon: Icon(Icons.file_upload),
                        action: _imagePicked
                            ?
                            // pass upload picture function
                            () async {
                                await _uploadPicture();
                              }
                            : null,
                        colour: Color.fromARGB(255, 74, 169, 242)),
              ].where(notNull).toList(),
            ),
          )),
        ));
  }
}
