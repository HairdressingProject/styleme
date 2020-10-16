import 'package:app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPicture extends StatefulWidget {
  static final String routeName = '/uploadPicture';
  static const String defaultImageUrl = 'assets/icons/image_placeholder.png';

  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  bool imagePicked;
  String _imageUrl = UploadPicture.defaultImageUrl;
  File _image;
  List<File> _croppedImages = [];
  final picker = ImagePicker();
  final cropKey = GlobalKey<CropState>();

  Future<void> _cropImage() async {
    final crop = cropKey.currentState;
    final scale = crop.scale;
    final area = crop.area;

    if (area == null) {
      print('Could not crop, area is null');
    }

    print('Scale: $scale, Area: $area');

    final sampledFile = await ImageCrop.sampleImage(
        file: _image,
        preferredWidth: (512 / crop.scale).round(),
        preferredHeight: (512 / crop.scale).round());

    final croppedFile =
        await ImageCrop.cropImage(file: sampledFile, area: crop.area);

    setState(() {
      _croppedImages.add(croppedFile);
    });
  }

  Widget _buildCropImage() {
    return Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 400,
        child: _croppedImages.isNotEmpty
            ? Crop(
                key: cropKey,
                image: FileImage(_croppedImages.last),
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
              )
            : Crop(
                key: cropKey,
                image: FileImage(_image),
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
              ));
  }

  @override
  void initState() {
    super.initState();
    imagePicked = false;
  }

  Future getImageFromCamera() async {
    final pickedImg = await picker.getImage(source: ImageSource.camera);

    setState(() {
      /// This null check avoids crashes if the user taps the "back" button when they are choosing an image
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        imagePicked = true;
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedImg = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      /// This null check avoids crashes if the user taps the "back" button when they are choosing an image
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        imagePicked = true;
      }
    });
  }

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload your picture',
            style: TextStyle(fontFamily: 'Klavika'),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 50.0),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                SvgPicture.asset('assets/icons/upload_your_picture_top.svg',
                    semanticsLabel: 'Upload your picture'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                  child: Column(
                    children: [
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
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0)),
                      ActionButton(
                          text: 'Take a picture',
                          icon: Icon(Icons.photo_camera),
                          action: getImageFromCamera,
                          colour: Color.fromARGB(255, 124, 62, 233)),
                    ],
                  ),
                ),

                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                // _image == null ? Image.asset(_imageUrl) : Image.file(_image),
                _image == null ? Image.asset(_imageUrl) : _buildCropImage(),
                _croppedImages.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 10.0),
                        child: ActionButton(
                          text: 'Undo',
                          colour: Color.fromARGB(255, 249, 9, 17),
                          icon: Icon(Icons.undo),
                          action: () {
                            setState(() {
                              _croppedImages.removeLast();
                            });
                          },
                        ))
                    : null,
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ActionButton(
                      text: 'Crop image',
                      icon: Icon(Icons.image_aspect_ratio),
                      action: imagePicked
                          ? () async {
                              await _cropImage();
                            }
                          : null,
                      colour: Color.fromARGB(255, 1, 100, 38),
                    )),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ActionButton(
                        text: 'Upload',
                        icon: Icon(Icons.file_upload),
                        action: imagePicked
                            ?
                            // pass upload picture function
                            () {
                                print("Image picked");
                              }
                            : null,
                        colour: Color.fromARGB(255, 74, 169, 242))),
              ].where(notNull).toList(),
            ),
          )),
        ));
  }
}
