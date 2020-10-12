import 'package:flutter/material.dart';


class FaceCard extends StatelessWidget {
  FaceCard({Key key, this.faceShape, this.faceShapePicture}) : super(key: key);

  final String faceShape;
  final String faceShapePicture;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            // width: 300,
            // height: 100,
            color: Colors.red,
            child: Column(
              children: [
                 Image.asset(faceShapePicture),
                 const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                 Text(faceShape)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
