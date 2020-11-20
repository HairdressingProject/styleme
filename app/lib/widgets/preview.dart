import 'package:app/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Preview extends StatelessWidget {
  final String assetPath;
  final String previewPictureUrl;
  final String origin;
  final String userToken;

  const Preview({
    Key key,
    this.previewPictureUrl,
    this.origin = ADMIN_PORTAL_URL,
    this.userToken,
    this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 96, 96, 96),
        appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
            title: Text(
              'Current picture preview',
              style: TextStyle(fontFamily: 'Klavika'),
            )),
        body: Container(
            child: PhotoView(
                enableRotation: false,
                loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(),
                    ),
                loadFailedChild: Center(
                    child: Icon(
                  Icons.broken_image,
                  size: 128.0,
                )),
                imageProvider: assetPath != null
                    ? Image.asset(assetPath).image
                    : NetworkImage(previewPictureUrl, headers: {
                        "Origin": origin,
                        "Authorization": "Bearer $userToken"
                      }))));
  }
}
