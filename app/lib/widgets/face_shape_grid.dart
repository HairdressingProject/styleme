import 'package:app/widgets/face_shape_card.dart';
import 'package:flutter/material.dart';

class FaceShapeGrid extends StatelessWidget {
  const FaceShapeGrid({Key key, @required this.faceShapes}) : super(key: key);

  final List<FaceShapeCard> faceShapes;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        children: faceShapes);
  }
}
