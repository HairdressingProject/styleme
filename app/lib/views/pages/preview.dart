import 'package:app/models/picture.dart';
import 'package:app/services/pictures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  final Picture picture;

  const Preview({Key key, @required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview',
          style: TextStyle(fontFamily: 'Klavika'),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: '${PicturesService.picturesUri}/file/${picture.id}',
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
