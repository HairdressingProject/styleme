import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadPicture extends StatefulWidget {
  static final String routeName = '/uploadPicture';

  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {


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
            padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 50.0),
            child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0)
              ),
              SvgPicture.asset(
                'assets/icons/upload_your_picture_top.svg',
                semanticsLabel: 'Upload your picture'
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Text(
                'Upload your picture',
                style: Theme.of(context).textTheme.headline1,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              CustomButton(
                text: 'Choose from your gallery',
                icon: Icon(Icons.photo_library),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0)
              ),
              CustomButton(
                text: 'Take a picture',
                icon: Icon(Icons.photo_camera)
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0)
              ),
              CustomButton(
                text: 'Upload',
                icon: Icon(Icons.file_upload)
              ),
            ],
          ),
          )
        ),
      )
    );
  }
}